#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf ncurses-6.0
tar -xf /tools/src/ncurses-6.0.tar.gz
cd ncurses-6.0

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

./configure \
    --prefix=/usr \
    --mandir=/usr/share/man \
    --with-shared           \
    --without-debug         \
    --without-normal        \
    --enable-pc-files       \
    --enable-widec          \
    \
    && make -j8 \
    && make install \
    && {
        mv /usr/lib/libncursesw.so.6* /lib
        ln -sf ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
        for lib in ncurses form panel menu ; do
            rm -f                     /usr/lib/lib${lib}.so
            echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
            ln -sf ${lib}w.pc         /usr/lib/pkgconfig/${lib}.pc
        done
        rm -f                      /usr/lib/libcursesw.so
        echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
        ln -sf libncurses.so       /usr/lib/libcurses.so
    }
}

time { build > /tmp/build/lastbuild.log; }
