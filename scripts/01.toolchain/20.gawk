#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf gawk-4.1.4
tar -xf ../src/gawk-4.1.4.tar.xz
cd gawk-4.1.4

function build() {
./configure --prefix=/tools \
    > /dev/null \
    && make > /dev/null \
    && make install > /dev/null
}

time build
