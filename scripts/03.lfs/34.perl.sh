#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf perl-5.24.1
tar -xf /tools/src/perl-5.24.1.tar.bz2
cd perl-5.24.1

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib \
    && make -j8 \
    && make -k test \
    && make install

unset BUILD_ZLIB BUILD_BZIP2
}

time { build > /tmp/build/lastbuild.log; }
