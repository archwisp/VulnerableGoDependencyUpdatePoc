# Vulnerable Dependency Update Notes

The goals of this project are:

- Automatically scan a codebase for vulnerable dependencies
- Automatically advance the version number of vulnerable dependencies in the project manifest
- Test deploy the project in a container and verify that unit tests succeed
- If the tests pass, commit the dependency update and trigger a pull request
- If the tests fail, create a ticket containing failed test outputs


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
