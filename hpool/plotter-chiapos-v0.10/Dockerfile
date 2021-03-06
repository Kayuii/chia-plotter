FROM ubuntu:20.04 as builder

ARG VER=v0.10
ARG CHIAPOS=1.0.2
ENV CHIAPATH=chiapos-${CHIAPOS}
ENV PATH=$PATH:/opt
ENV TZ=Asia/Shanghai

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  cmake \
  git wget unzip \
  python3 \
  python3-dev \
  python3-distutils \
 && cp /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && cat /etc/timezone \
 && rm -rf /var/lib/apt/lists/*

RUN git clone -b $CHIAPOS git://github.com/Chia-Network/chiapos.git /opt/chiapos --depth 1

RUN mkdir -p /opt/chiapos/build \
  && cd /opt/chiapos \
  && sed -i "s/https/git/g" CMakeLists.txt \
  && cd /opt/chiapos/build \
  && cmake ../ \
  && cmake --build . -- -j `nproc` \
  && strip ProofOfSpace

RUN wget -qO /opt/tmp.zip --no-check-certificate https://github.com/hpool-dev/chia-plotter/releases/download/${VER}/chia-plotter-${VER}-x86_64-linux-gnu.zip && unzip /opt/tmp.zip -d /opt

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=builder /etc/localtime /etc
COPY --from=builder /etc/timezone /etc
COPY --from=builder /opt/chia-plotter /opt
COPY --from=builder /opt/chiapos/build/ProofOfSpace /opt

CMD ["/opt/chia-plotter-linux-amd64"]
