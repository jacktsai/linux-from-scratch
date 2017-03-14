#!/bin/bash
if [ -e /etc/lfs-release ]; then
    [ $(id -un) != 'root' ] && {
        echo '請用 root 使用者執行。'
        exit 1
    }
else
    [ $(id -un) != 'lfs' ] && {
        echo '請勿在非 LFS 環境請使用。'
        exit 1
    }
fi

SCRIPT_DIR=$(dirname $BASH_SOURCE[0])
mkdir /install-log 2> /dev/null

function install_pkg() {
    [ -e /install-log/$1 ] && {
        echo $1 already installed.
        return 0
    }

    printf '\nInstalling %s ...\n' $1
    $SCRIPT_DIR/install.sh $SCRIPT_DIR/03.lfs/$1 && {
        touch /install-log/$1
        return 0
    } || return 1
}

install_pkg linux-headers \
&& install_pkg man-pages \
&& install_pkg glibc \
&& install_pkg zlib \
&& install_pkg file \
&& install_pkg binutils \
&& install_pkg gmp \
&& install_pkg mpfr \
&& install_pkg mpc \
&& install_pkg gcc \
&& install_pkg bzip2 \
&& install_pkg pkg-config \
&& install_pkg ncurses \
&& install_pkg attr \
&& install_pkg acl \
&& install_pkg libcap \
&& install_pkg sed \
&& install_pkg shadow
&& install_pkg psmisc \
&& install_pkg iana-etc \
&& install_pkg m4 \
&& install_pkg bison \
&& install_pkg flex \
&& install_pkg grep