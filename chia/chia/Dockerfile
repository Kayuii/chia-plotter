FROM golang:alpine as builder

RUN apk update \
  && apk --no-cache add --virtual build-dependencies \
  zlib-dev build-base linux-headers coreutils git

ENV GOPROXY=https://goproxy.io,direct

WORKDIR /opt

RUN git clone https://github.com/Kayuii/chiacli.git /opt --depth 1 \
  && cd /opt \
  && make build-static

FROM python:3.7-slim

ARG CHIA_VER=v1.1.7

RUN pip install --extra-index-url https://hosted.chia.net/simple/ chia-blockchain==${CHIA_VER} miniupnpc==2.1

RUN chia init && mkdir -p /mnt/plot && chia plots add -d /mnt/plot

COPY --from=builder /opt/chiacli-static /usr/local/bin/chiacli

ENV PATH=$PATH:/opt
WORKDIR /opt
