#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf automake-1.15
tar -xf /tools/src/automake-1.15.tar.xz
cd automake-1.15

sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in

./configure \
    --prefix=/usr \
    --docdir=/usr/share/doc/automake-1.15 \
    \
    && make -j8 \
    && {
        sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
        make check
    } && {
        make install
    }
}

time { build > /tmp/build/lastbuild.log; }
