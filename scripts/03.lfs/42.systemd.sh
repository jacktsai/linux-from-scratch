#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf systemd-232
tar -xf /tools/src/systemd-232.tar.xz
cd systemd-232

sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
sed -e 's@test/udev-test.pl @@' -e 's@test-copy$(EXEEXT) @@' -i Makefile.in

echo "
KILL=/bin/kill
MOUNT_PATH=/bin/mount
UMOUNT_PATH=/bin/umount
HAVE_BLKID=1
BLKID_LIBS=-lblkid
BLKID_CFLAGS=-I/tools/include/blkid
HAVE_LIBMOUNT=1
MOUNT_LIBS=-lmount
MOUNT_CFLAGS=-I/tools/include/libmount
cc_cv_CFLAGS__flto=no
SULOGIN=/sbin/sulogin
XSLTPROC=/usr/bin/xsltproc" > config.cache

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --config-cache           \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir=/usr/share/doc/systemd-232 \
    \
    && make LIBRARY_PATH=/tools/lib -j8 \
    && make LD_LIBRARY_PATH=/tools/lib -j8 install \
    && {
        rm -rf /usr/lib/rpm
        for tool in runlevel reboot shutdown poweroff halt telinit; do
            ln -sf ../bin/systemctl /sbin/${tool}
        done
        ln -sf ../lib/systemd/systemd /sbin/init
        systemd-machine-id-setup
        sed -i "s:minix:ext4:g" src/test/test-path-util.c
        make LD_LIBRARY_PATH=/tools/lib -k -j8 check
    }
}

time { build > /tmp/build/lastbuild.log; }
