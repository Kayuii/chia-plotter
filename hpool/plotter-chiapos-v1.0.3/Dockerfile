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

FROM kayuii/chia-plotter:hplotter-v0.11 as hpool

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=hpool /etc/localtime /etc
COPY --from=hpool /etc/timezone /etc
COPY --from=hpool /opt/ /opt/
COPY --from=builder /opt/chiacli /opt
