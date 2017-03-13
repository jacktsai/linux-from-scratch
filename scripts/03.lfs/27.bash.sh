#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf bash-4.4
tar -xf /tools/src/bash-4.4.tar.gz
cd bash-4.4

patch --forward --strip=1 --input=/tools/src/bash-4.4-upstream_fixes-1.patch

./configure \
    --prefix=/usr \
    --docdir=/usr/share/doc/bash-4.4 \
    --without-bash-malloc               \
    --with-installed-readline \
    \
    && make -j8 \
    && chown -R nobody . \
    && su nobody -s /bin/bash -c "PATH=$PATH make tests" \
    && make install \
    && mv -f /usr/bin/bash /bin
}

time { build > /tmp/build/lastbuild.log; }
