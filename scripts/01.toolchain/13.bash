#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf bash-4.4
tar -xf ../src/bash-4.4.tar.gz
cd bash-4.4

function build() {
./configure --prefix=/tools --without-bash-malloc \
    > /dev/null \
    && make > /dev/null \
    && make tests \
    && make install > /dev/null \
    && ln -sv bash /tools/bin/sh
}

time build
