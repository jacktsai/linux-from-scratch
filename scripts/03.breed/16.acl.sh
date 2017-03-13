#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf acl-2.2.52
tar -xf /tools/src/acl-2.2.52.src.tar.gz
cd acl-2.2.52

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c

./configure \
    --prefix=/usr \
    --disable-static \
    --libexecdir=/usr/lib \
    \
    && make -j8 \
    && make install install-dev install-lib \
    && {
        chmod 755 /usr/lib/libacl.so
        mv v /usr/lib/libacl.so.* /lib
        ln -sf ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
    }
}

time { build > /tmp/build/lastbuild.log; }
