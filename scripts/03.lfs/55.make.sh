#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf make-4.2.1
tar -xf /tools/src/make-4.2.1.tar.bz2
cd make-4.2.1

./configure \
    --prefix=/usr \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
