#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf util-linux-2.29.1
tar -xf /tools/src/util-linux-2.29.1.tar.xz
cd util-linux-2.29.1

mkdir -p /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.29.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --enable-libmount-force-mountinfo \
    \
    && make -j8 \
    && make install
}

time { build > /tmp/build/lastbuild.log; }
