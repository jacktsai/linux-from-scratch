#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf libcap-2.25
tar -xf /tools/src/libcap-2.25.tar.xz
cd libcap-2.25

sed -i '/install.*STALIBNAME/d' libcap/Makefile

make -j8 \
    && make RAISE_SETFCAP=no lib=lib prefix=/usr install \
    && chmod 755 /usr/lib/libcap.so
}

time { build > /tmp/build/lastbuild.log; }
