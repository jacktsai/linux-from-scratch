#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf sed-4.4
tar -xf /tools/src/sed-4.4.tar.xz
cd sed-4.4

sed -i 's/usr/tools/'       build-aux/help2man
sed -i 's/panic-tests.sh//' Makefile.in

./configure \
    --prefix=/usr \
    --bindir=/bin \
    \
    && make -j8 \
    && make html \
    && make check \
    && {
        make install
        install -d -m755           /usr/share/doc/sed-4.4
        install -m644 doc/sed.html /usr/share/doc/sed-4.4
    }
}

time { build > /tmp/build/lastbuild.log; }
