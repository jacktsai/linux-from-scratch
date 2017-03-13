#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf make-4.2.1
tar -xf ../src/make-4.2.1.tar.bz2
cd make-4.2.1

function build() {
./configure --prefix=/tools --without-guile \
    > /dev/null \
    && make > /dev/null \
    && make check \
    && make install > /dev/null
}

time build
