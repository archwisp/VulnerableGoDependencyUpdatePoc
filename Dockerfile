FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update;
# RUN apt-get install -y iproute2 curl build-essential cmake libssl-dev openssl file git pkg-config libdbus-1-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev checkinstall unzip llvm wabt;
# RUN apt-get install -y protobuf-compiler capnproto
RUN apt-get install -y sudo wget curl git vim net-tools pip python3-full
RUN wget https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
RUN python3 -m venv /root/semgrep-venv
RUN /root/semgrep-venv/bin/python3 -m pip install semgrep
