#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf gperf-3.0.4
tar -xf /tools/src/gperf-3.0.4.tar.gz
cd gperf-3.0.4

./configure \
    --prefix=/usr \
    --docdir=/usr/share/doc/gperf-3.0.4 \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
