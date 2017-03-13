#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf intltool-0.51.0
tar -xf /tools/src/intltool-0.51.0.tar.gz
cd intltool-0.51.0

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure \
    --prefix=/usr \
    \
    && make -j8 \
    && make check \
    && make install \
    && install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
}

time { build > /tmp/build/lastbuild.log; }
