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
    $SCRIPT_DIR/install.sh $SCRIPT_DIR/03.toolchain/$1 && {
        touch /install-log/$1
        return 0
    } || return 1
}

linux_headers \
&& install_pkg man_pages \
&& install_pkg glibc
