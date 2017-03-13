#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf expat-2.2.0
tar -xf /tools/src/expat-2.2.0.tar.bz2
cd expat-2.2.0

./configure \
    --prefix=/usr \
    --disable-static \
    \
    && make -j8 \
    && make check \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
