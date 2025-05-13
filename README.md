# Vulnerable Go Dependency Update PoC

The goals of this project are:

1. Build a container that will run Go packages
2. Test deploy the project in the container and verify that it runs and unit tests pass
3. Automatically scan the codebase for vulnerable dependencies
4. Automatically advance the version number of vulnerable dependencies in the project manifest
5. Re-deploy the project in a container with the new dependency version and verify that it still runs and unit tests still pass
6. If the tests pass, commit the dependency update and trigger a pull request
7. If the tests fail, create a ticket containing failed test outputs

# Run the PoC
This shell script runs steps 1-5 on the included code in `./src` and returns the
exit code of any of the subprocesses. A complete variant would download an
arbitrary package instead, and be plumbed into whatever ticketing system is
being used.

```
./run-poc.sh
```

# Step-by-step

## Build the container

```
docker build -t archwisp/vulnerable-dependency-update-poc .
```

## Run the program to make sure it works

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .
warning: both GOPATH and GOROOT are the same directory (/usr/local/go); see https://go.dev/wiki/InstallTroubleshooting
go: downloading golang.org/x/text v0.3.5
Hello, Bob. Welcome!
```

## Run unit tests

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test
warning: both GOPATH and GOROOT are the same directory (/usr/local/go); see https://go.dev/wiki/InstallTroubleshooting
go: downloading golang.org/x/text v0.3.5
PASS
ok      Main    0.002s
```

## Run the vuln check

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc /usr/local/go/bin/linux_arm64/govulncheck .
=== Symbol Results ===

Vulnerability #1: GO-2021-0113
    Out-of-bounds read in golang.org/x/text/language
  More info: https://pkg.go.dev/vuln/GO-2021-0113
  Module: golang.org/x/text
    Found in: golang.org/x/text@v0.3.5
    Fixed in: golang.org/x/text@v0.3.7
    Example traces found:
      #1: main.go:12:43: Main.main calls language.Parse

Your code is affected by 1 vulnerability from 1 module.
This scan also found 1 vulnerability in packages you import and 0
vulnerabilities in modules you require, but your code doesn't appear to call
these vulnerabilities.
Use '-show verbose' for more details.
```

## Create the vulncheck logfile

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc /usr/local/go/bin/linux_arm64/govulncheck . > src/vulncheck.log
```

## Patch the version

```
python3 scripts/update-vuln-dependencies.py src/go.mod src/vulncheck.log
Processing module file: src/go.mod
Processing vulncheck file: src/vulncheck.log
Found Vulnerability #1: GO-2021-0113 on line 2
Vuln is in golang.org/x/text@v0.3.5 on line 6
Fix is in golang.org/x/text@v0.3.7 on line 7
[{"lib": "golang.org/x/text", "vuln_version": "v0.3.5", "fix_version": "v0.3.7"}]
Found match for golang.org/x/text on line number 6
Updating version from v0.3.5 to v0.3.7
```

## Run the the dependecy update

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go get Main
warning: both GOPATH and GOROOT are the same directory (/usr/local/go); see https://go.dev/wiki/InstallTroubleshooting
go: downloading golang.org/x/text v0.3.7
```

## Make sure the program still runs

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go run .
warning: both GOPATH and GOROOT are the same directory (/usr/local/go); see https://go.dev/wiki/InstallTroubleshooting
go: downloading golang.org/x/text v0.3.7
Hello, Bob. Welcome!
```

## Make sure unit tests still pass

```
docker run --rm -it --name vulnerable-dependency-update-poc -v ./src:/src archwisp/vulnerable-dependency-update-poc go test
warning: both GOPATH and GOROOT are the same directory (/usr/local/go); see https://go.dev/wiki/InstallTroubleshooting
go: downloading golang.org/x/text v0.3.7
PASS
ok      Main    0.002s
```

# References
- https://go.dev/doc/tutorial/govulncheck
