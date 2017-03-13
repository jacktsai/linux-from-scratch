#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf grep-3.0
tar -xf /tools/src/grep-3.0.tar.xz
cd grep-3.0

./configure \
    --prefix=/usr \
    --bindir=/bin \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
