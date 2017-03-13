#!/bin/bash
[ ! -e /etc/lfs-release ] && {
    echo 請在 LFS 環境執行!
    exit 0
}

function build() {
cd /tmp/build
rm -rf coreutils-8.26
tar -xf /tools/src/coreutils-8.26.tar.xz
cd coreutils-8.26

patch --forward --strip=1 --input=/tools/src/coreutils-8.26-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime \
    \
    && FORCE_UNSAFE_CONFIGURE=1 make -j8 \
    && make NON_ROOT_USERNAME=nobody check-root \
    && {
        echo "dummy:x:1000:nobody" >> /etc/group
        chown -Rv nobody .
        su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
        sed -i '/dummy/d' /etc/group
    } \
    && make install \
    && {
        mv /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
        mv /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
        mv /usr/bin/{rmdir,stty,sync,true,uname} /bin
        mv /usr/bin/chroot /usr/sbin
        mv /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
        sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
        mv /usr/bin/{head,sleep,nice,test,[} /bin
    }
}

time { build > /tmp/build/lastbuild.log; }
