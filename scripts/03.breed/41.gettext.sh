#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf gettext-0.19.8.1
tar -xf /tools/src/gettext-0.19.8.1.tar.xz
cd gettext-0.19.8.1

sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in \
    && sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

./configure \
    --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/gettext-0.19.8.1 \
    \
    && make -j8 \
    && make check \
    && make install \
    && chmod 0755 /usr/lib/preloadable_libintl.so
}

time { build > /tmp/build/lastbuild.log; }
