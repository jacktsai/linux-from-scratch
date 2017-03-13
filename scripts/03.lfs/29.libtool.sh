#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf libtool-2.4.6
tar -xf /tools/src/libtool-2.4.6.tar.xz
cd libtool-2.4.6

./configure \
    --prefix=/usr \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
