#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf bc-1.06.95
tar -xf /tools/src/bc-1.06.95.tar.bz2
cd bc-1.06.95

patch --forward --strip=1 --input=/tools/src/bc-1.06.95-memory_leak-1.patch

./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info \
    \
    && make -j8 \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
