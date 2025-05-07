FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update;
RUN apt-get install -y wget 
RUN wget https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV GOARCH=arm64
ENV PATH=$GOROOT/bin:$GOPATH/bin/linux_$GOARCH:$PATH
RUN go install golang.org/x/vuln/cmd/govulncheck@latest
WORKDIR /src
