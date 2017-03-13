#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf m4-1.4.18
tar -xf /tools/src/m4-1.4.18.tar.xz
cd m4-1.4.18

./configure \
    --prefix=/usr \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
