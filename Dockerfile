FROM golang:1.7.5-alpine3.5

ARG TELEGRAF_VERSION=1.2.1
ARG GOPATH=/go

COPY plugins/inputs/docker/docker.go /tmp/docker.go

RUN apk --no-cache add --virtual build-dependencies \
      git \
      build-base \
      gnupg &&\
    echo "" &&\
    go version &&\
    echo "" &&\
    mkdir -p ${GOPATH}/src/github.com/influxdata/ &&\
    git clone https://github.com/ddm/telegraf.git ${GOPATH}/src/github.com/influxdata/telegraf &&\
    cd ${GOPATH}/src/github.com/influxdata/telegraf &&\
    git checkout ${TELEGRAF_VERSION} &&\
    mv /tmp/docker.go plugins/inputs/docker/ &&\
    make &&\
    mv ${GOPATH}/bin/telegraf /usr/bin/telegraf &&\
    rm -rf ${GOPATH} &&\
    apk del --purge build-dependencies
