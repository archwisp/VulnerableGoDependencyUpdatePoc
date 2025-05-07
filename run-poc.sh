#!/bin/bash

echo "[PoC] Building Go docker image"
## Build the container
docker build -t archwisp/vulnerable-dependency-update-poc . -q;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

## Cleanup the docker environment just in case
echo "[PoC] Cleaning up docker PoC instances"
docker ps -a --filter name=vulnerable-dependency-update-poc -q | xargs docker rm;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

## Run vulncheck
echo "[PoC] Running vulncheck"
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc govulncheck . > src/vulncheck.log;

if [ "$?" -eq "127" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi


NO_VULNS_FOUND=$(fgrep "No vulnerabilities found." src/vulncheck.log);

if [ -n "$NO_VULNS_FOUND" ]; then
    echo "[PoC] No vulnerable dependencies found. Exiting.";
    echo "[PoC] If you already ran the PoC and want to re-run it, issue \`git stash\` command and try again.";
    exit;
else
    echo "[PoC] Found vulnerable dependencies."
fi

echo "[PoC] Running Go program to ensure it runs."
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

echo "[PoC] Running unit tests to ensure they pass."
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

echo "[PoC] Updating vulnerable dependency versions"
python3 scripts/update-vuln-dependencies.py src/go.mod src/vulncheck.log;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

echo "[PoC] Deploying dependency update"
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go get Main;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

echo "[PoC] Running Go program to ensure it still runs."
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi

echo "[PoC] Running unit tests to ensure they still pass."
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test;

if [ "$?" -ne "0" ]; then
    echo "[PoC] Exiting because last command failed.";
    exit;
fi
