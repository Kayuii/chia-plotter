# Compiler image
# -------------------------------------------------------------------------------------------------
FROM ubuntu:20.04 AS compiler

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

RUN  sed -i "s@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
 && sed -i "s@http://.*security.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y \
  build-essential \
  ca-certificates \
  gcc \
  g++ \
  libsodium-dev \
  cmake \
  git \
  libnuma-dev

ENV CIBUILDWHEEL 1

RUN git clone --recursive https://github.com/harold-b/bladebit.git --depth 1 \
  && cd bladebit \
  && ./build-bls \
  && make clean && make -j$(nproc --all) \
  && .bin/release/bladebit -h

# Runtime image
# -------------------------------------------------------------------------------------------------
FROM ubuntu:20.04 AS runtime

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=compiler /opt/bladebit/.bin/release/bladebit /opt/bladebit

RUN  sed -i "s@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
 && sed -i "s@http://.*security.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y \
 libnuma-dev

RUN ln -s /opt/bladebit /usr/bin/bladebit
