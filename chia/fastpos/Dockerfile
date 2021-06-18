# Compiler image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.14 AS compiler

WORKDIR /opt

RUN apk --no-cache add \
    gcc \
    g++ \
    build-base \
    cmake \
    gmp-dev \
    libsodium-dev \
    libsodium-static \
    git

ENV CIBUILDWHEEL 1

RUN git clone https://github.com/madMAx43v3r/chia-plotter.git /opt/fastpos --depth 1 \
  && cd fastpos \
  && git submodule update --init \
  && mkdir -p build \
  && cd build \
  && cmake -D CMAKE_CXX_FLAGS="-O3 -fmax-errors=1" -DARITH="easy" -DBUILD_BLS_PYTHON_BINDINGS=false ../ \
  && cmake --build . -- -j `nproc` \
  && strip chia_plot

# -DCMAKE_EXE_LINKER_FLAGS="-static"

FROM golang:alpine as builder

RUN apk update \
  && apk --no-cache add --virtual build-dependencies \
  zlib-dev build-base linux-headers coreutils git

ENV GOPROXY=https://goproxy.io,direct

WORKDIR /opt

RUN git clone https://github.com/Kayuii/chiacli.git /opt --depth 2 \
  && cd /opt \
  && make build-static

# Runtime image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.14 AS runtime

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=builder /opt/chiacli-static /opt/chiacli
COPY --from=compiler /opt/fastpos/build/chia_plot /opt/fastpos

RUN apk --no-cache add \
    gmp-dev \
    libsodium-dev

RUN ln -s /opt/fastpos /usr/bin/fastpos \
  && ln -s /opt/chiacli /usr/bin/chiacli
