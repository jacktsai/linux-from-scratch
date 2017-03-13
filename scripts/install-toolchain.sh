#!/bin/bash
if [ -e /etc/lfs-release ]; then
    [ $(id -un) != 'root' ] && {
        echo '在 LFS 環境請使用 root 使用者執行.'
        exit 1
    }
else
    [ $(id -un) != 'lfs' ] && {
        echo '在非 LFS 環境請使用 lfs 使用者執行.'
        exit 1
    }
fi
