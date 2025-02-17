# Build golang project that listen on port 8080 and use tor
FROM golang:1.17.2-buster
RUN apt update && apt upgrade -y && apt install -y tor obfs4proxy
WORKDIR /app

COPY go.mod ./
# COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /docker-gs-ping

EXPOSE 8080

ARG SCHEME
ARG HOST

RUN wget https://github.com/nicolas-van/multirun/releases/download/1.0.0/multirun-glibc-1.0.0.tar.gz && \
  tar -zxvf multirun-glibc-1.0.0.tar.gz && \
  mv multirun /bin && \
  rm multirun-glibc-1.0.0.tar.gz

ENTRYPOINT ["multirun", "tor", "/docker-gs-ping"]