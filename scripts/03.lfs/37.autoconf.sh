#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf autoconf-2.69
tar -xf /tools/src/autoconf-2.69.tar.xz
cd autoconf-2.69

./configure \
    --prefix=/usr \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
