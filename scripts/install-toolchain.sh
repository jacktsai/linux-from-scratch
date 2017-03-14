#!/bin/bash
if [ -e /etc/lfs-release ]; then
    echo '請勿在 LFS 環境請使用。'
    exit 1
else
    [ $(id -un) != 'lfs' ] && {
        echo '請先切換至 lfs 使用者。'
        exit 1
    }
fi

SCRIPT_DIR=$(dirname $BASH_SOURCE[0])
mkdir /tools/install-log 2> /dev/null

function install_pkg() {
    [ -e /tools/install-log/$1 ] && {
        echo $1 already installed.
        return 0
    }

    printf '\nInstalling %s ...\n' $1
    $SCRIPT_DIR/install.sh $SCRIPT_DIR/01.toolchain/$1 && {
        touch /tools/install-log/$1
        return 0
    } || return 1
}

install_pkg binutils-cross \
&& install_pkg gcc-cross \
&& install_pkg linux-headers \
&& install_pkg glibc \
&& install_pkg libstdc++ \
&& install_pkg binutils \
&& install_pkg gcc \
&& install_pkg tcl-core \
&& install_pkg expect \
&& install_pkg dejagu \
&& install_pkg check \
&& install_pkg ncurses \
&& install_pkg bash \
&& install_pkg bison \
&& install_pkg bzip2 \
&& install_pkg coreutils \
&& install_pkg diffutils \
&& install_pkg file \
&& install_pkg findutils \
&& install_pkg gawk \
&& install_pkg gettext