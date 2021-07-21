FROM ubuntu:20.04 as builder

ARG CHIAPOS=1.0.3
ARG BUILD_PROOF_OF_SPACE_STATICALLY=OFF
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
  && if [ "x$BUILD_PROOF_OF_SPACE_STATICALLY" = "xON" ]; then sed -i "s/target_link_libraries(ProofOfSpace fse stdc++fs Threads::Threads)/target_link_libraries(ProofOfSpace \"-static -Wl,--whole-archive -lrt -lpthread -Wl,--no-whole-archive\" fse stdc++fs Threads::Threads )/g" CMakeLists.txt; fi \
  && cd /opt/chiapos/build \
  && cmake ../ \
  && cmake --build . -- -j `nproc` \
  && strip ProofOfSpace

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=builder /etc/localtime /etc
COPY --from=builder /etc/timezone /etc
COPY --from=builder /opt/chiapos/build/ /opt/build
COPY --from=builder /opt/chiapos/build/ProofOfSpace /opt

CMD ["ProofOfSpace"]
