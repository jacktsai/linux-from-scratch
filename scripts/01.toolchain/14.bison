#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf bison-3.0.4
tar -xf ../src/bison-3.0.4.tar.xz
cd bison-3.0.4

function build() {
./configure --prefix=/tools \
    > /dev/null \
    && make > /dev/null \
    && make check \
    && make install > /dev/null
}

time build
