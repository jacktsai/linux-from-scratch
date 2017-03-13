#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf m4-1.4.18
tar -xf ../src/m4-1.4.18.tar.xz
cd m4-1.4.18

function build() {
./configure --prefix=/tools \
    > /dev/null \
    && make > /dev/null \
    && make check \
    && make install > /dev/null
}

time build
