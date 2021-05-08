FROM ubuntu:20.04 as builder

ARG VER=v0.11
ARG CHIAPOS=1.0.1
ENV CHIAPATH=chiapos-${CHIAPOS}
ENV PATH=$PATH:/opt
ENV TZ=Asia/Shanghai

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    wget unzip tzdata \
 && cp /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && cat /etc/timezone \
 && rm -rf /var/lib/apt/lists/*

RUN wget -q -O /opt/tmp.zip --no-check-certificate https://github.com/hpool-dev/chia-plotter/releases/download/${VER}/chia-plotter-${VER}-x86_64-linux-gnu.zip && unzip /opt/tmp.zip -d /opt

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=builder /etc/localtime /etc
COPY --from=builder /etc/timezone /etc
COPY --from=builder /opt/chia-plotter /opt

CMD ["/opt/chia-plotter-linux-amd64"]
