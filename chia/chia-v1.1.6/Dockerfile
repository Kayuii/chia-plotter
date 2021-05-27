FROM golang:alpine as builder

ENV VER=v0.1

RUN apk update \
  && apk --no-cache add --virtual build-dependencies \
  zlib-dev build-base linux-headers coreutils

ENV GOPROXY=https://goproxy.io,direct

WORKDIR /opt

RUN wget -qO - --no-check-certificate https://github.com/Kayuii/chiacli/archive/refs/tags/${VER}.tar.gz | tar xz --strip-components=1 -C /opt \
  && cd /opt \
  && make build-static

FROM python:3.7-slim

RUN pip install --extra-index-url https://hosted.chia.net/simple/ chia-blockchain==1.1.6 miniupnpc==2.1

RUN chia init

COPY --from=builder /opt/chiacli-static /usr/local/bin/chiacli

WORKDIR /root
