FROM ubuntu:20.04 as builder

ARG VER=v1.2.0-4
ARG TARGETARCH
ARG ARCH
ENV PATH=$PATH:/opt
ENV TZ=Asia/Shanghai

COPY arch.sh /tmp/arch.sh

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
  ca-certificates \
  git wget unzip tzdata \
 && cp /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && cat /etc/timezone \
 && mkdir -p /tmp/linux \
 && /tmp/arch.sh ${VER} \
 && mv /tmp/linux/* /opt/ \
 && rm -rf /var/lib/apt/lists/*

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=builder /etc/localtime /etc
COPY --from=builder /etc/timezone /etc
COPY --from=builder /opt/ /opt/

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends curl
