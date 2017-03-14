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


SH_DIR=$(dirname $BASH_SOURCE[0])
mkdir /install_log 2> /dev/null

function install_pkg() {
    echo installing $1 ...
    if [ -e /install_log/$1 ]; then
        return 0
    fi

    SH_DIR/install.sh SH_DIR/03.lfs/$1 && return 0 || return 1
}

install_pkg linux_headers && \
install_pkg man_pages && \
install_pkg glibc
