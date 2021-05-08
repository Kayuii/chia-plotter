#!/bin/sh
if [ `arch` = "x86_64" ] ; then ARCH=linux;fi
if [ `arch` = "aarch64" ] ; then ARCH=aarch64;fi
if [ `arch` = "armv7l" ] ; then ARCH=arm;fi
VER=$1
wget -q --no-check-certificate https://github.com/hpool-dev/chia-miner/releases/download/${VER}/HPool-Miner-chia-${VER}-${ARCH}.zip -O /tmp/chia-miner.zip && unzip -j /tmp/chia-miner.zip -d /tmp/linux
