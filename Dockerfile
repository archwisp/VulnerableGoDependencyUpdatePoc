FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update;
RUN apt-get install -y sudo wget curl git vim net-tools 
RUN wget https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go
ENV GOPATH=$GOROOT
ENV GOARCH=arm64
# RUN apt-get install -y pip python3-full
# RUN python3 -m venv /root/semgrep-venv
# RUN /root/semgrep-venv/bin/python3 -m pip install semgrep
# RUN echo "go install is in $GOROOT"
ENV PATH=$GOROOT/bin:$GOROOT/bin/$GOARCH:$PATH
RUN echo "PATH is $PATH"
RUN go install github.com/securego/gosec/v2/cmd/gosec@latest
RUN go install golang.org/x/vuln/cmd/govulncheck@latest
WORKDIR /src
# RUN cd $INSTALL_DIR && govulncheck .
