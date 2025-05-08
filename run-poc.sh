#!/bin/bash

function handle_error {
    CODE=$1
    EXPECTED_VALUES=$2

    for EXPECTED_VALUE in $EXPECTED_VALUES
    do
        if [ "$CODE" -eq "$EXPECTED_VALUE" ]; then
            return 0;
        fi
    done

    echo "[PoC] Exiting because last command failed.";
    exit $CODE;
}

echo "[PoC] Building Go docker image"

## Build the container
echo
docker build -t archwisp/vulnerable-dependency-update-poc . -q;
handle_error $? "0";
echo

## Cleanup the docker environment just in case
echo "[PoC] Cleaning up docker PoC instances"
docker ps -a --filter name=vulnerable-dependency-update-poc -q | xargs docker rm;
handle_error $? "0";

echo "[PoC] Running Go program to ensure it runs."
echo
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .;
handle_error $? "0";
echo

echo "[PoC] Running unit tests to ensure they pass."
echo
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test;
handle_error $? "0";
echo

## Run vulncheck
echo "[PoC] Running vulncheck"
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc govulncheck -show verbose . > src/vulncheck.log;
handle_error $? "0 3";

NO_VULNS_FOUND=$(fgrep "No vulnerabilities found." src/vulncheck.log);

if [ -n "$NO_VULNS_FOUND" ]; then
    echo "[PoC] No vulnerable dependencies found. Exiting.";
    echo "[PoC] If you already ran the PoC and want to re-run it, issue \`git stash\` command and try again.";
    exit;
else
    echo "[PoC] Found vulnerable dependencies."
fi

echo "[PoC] Updating vulnerable dependency versions"
echo
python3 scripts/update-vuln-dependencies.py src/go.mod src/vulncheck.log;
handle_error $? "0";
echo

echo "[PoC] Deploying dependency update"
echo
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go get Main;
handle_error $? "0";
echo

echo "[PoC] Running Go program to ensure it still runs."
echo
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .;
handle_error $? "0";
echo

echo "[PoC] Running unit tests to ensure they still pass."
echo
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test;
handle_error $? "0";
echo
