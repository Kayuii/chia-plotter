FROM golang:alpine as builder

ARG CHIACLI_VER=v0.4

RUN apk update \
  && apk --no-cache add --virtual build-dependencies \
  zlib-dev build-base linux-headers coreutils

ENV GOPROXY=https://goproxy.io,direct

WORKDIR /opt

RUN wget -qO - --no-check-certificate https://github.com/Kayuii/chiacli/archive/refs/tags/${CHIACLI_VER}.tar.gz | tar xz --strip-components=1 -C /opt \
  && cd /opt \
  && make build-static

FROM python:3.7-slim

ARG CHIA_VER=v1.1.7

RUN pip install --extra-index-url https://hosted.chia.net/simple/ chia-blockchain==${CHIA_VER} miniupnpc==2.1

RUN chia init && mkdir -p /mnt/plot && chia plots add -d /mnt/plot

COPY --from=builder /opt/chiacli-static /usr/local/bin/chiacli

ENV PATH=$PATH:/opt
WORKDIR /opt
