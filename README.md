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

## Run the container
```
docker run -it -d --name vulnerable-dependency-update-poc -v ./src:/root/.local/share/poc archwisp/vulnerable-dependency-update-poc
```

```
65f26fcfd88930e8f40c73d501374c80d92c9544618c221c3fe0474325935da7
```

```
docker ps
```

```
CONTAINER ID   IMAGE                                       COMMAND       CREATED         STATUS         PORTS     NAMES
65f26fcfd889   archwisp/vulnerable-dependency-update-poc   "/bin/bash"   4 seconds ago   Up 3 seconds             vulnerable-dependency-update-poc
```

```
docker exec -it 65f26fcfd889 /bin/bash
root@65f26fcfd889:/#
```

## Run the PoC app manually
```
cd /root/.local/share/poc
/usr/local/go/bin/go get
/usr/local/go/bin/go run main.go
```
