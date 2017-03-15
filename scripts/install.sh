#!/bin/bash
if [ -e /etc/lfs-release ]; then
    [ $(id -un) != 'root' ] && {
        echo '在 LFS 環境請使用 root 使用者執行。'
        exit 1
    }
else
    [ $(id -un) != 'lfs' ] && {
        echo '在非 LFS 環境請使用 lfs 使用者執行。'
        exit 1
    }
fi

[ $# -lt 1 ] && {
    printf 'Usage: %s [module name]\n' $(basename $0)
    exit 1
}

MODULE=$1

[ ! -e $MODULE ] && {
    printf 'Module "%s" Not Found !!\n' $MODULE
    exit 1
}

# 載入模組並設定變數
source $MODULE
SRC_DIR='/tools/src'
WORK_DIR='/tmp/build'
mkdir $WORK_DIR 2> /dev/null
PKG_NAME=$(tar_name)
PKG_DIR=$(tar_dir)
CHECK_PKG=0

[ ! -e $WORK_DIR ] && {
    printf 'WORK_DIR "%s" Not Found !!\n' $WORK_DIR
    exit 101
}

# args=`getopt -l without-check -- "$@"`
# while true; do
#     case $1 in
#         --without-check)
#             CHECK_PKG=0
#             shift;;
#     esac
# done

function install_flow() {
    cd $WORK_DIR
    [ -e $PKG_DIR ] && rm -rf $PKG_DIR

    if [ -e $SRC_DIR/$PKG_NAME ]; then
        tar xf $SRC_DIR/$PKG_NAME
    else
        return 102
    fi

    [ -e $PKG_DIR ] && cd $PKG_DIR || {
        return 103
    }

    printf "[[[ BEGIN CONFIG ]]]\n"
    config_pkg && {
        printf "[[[ BEGIN MAKE ]]]\n"
        make_pkg && {

            [ $CHECK_PKG -eq 1 ] && {
                printf "[[[ BEGIN CHECK ]]]\n"
                check_pkg || return 106
            }

            printf "[[[ BEGIN INSTALL ]]]\n"
            install_pkg && return 0 || return 107
        } || return 105
    } || return 104
}

function print_result() {
    case $1 in
        102)    printf 'Package "%s" Not Found !!\n' $SRC_DIR/$PKG_NAME;;
        103)    printf 'Source code directory "%s" Not Found !!\n' $PKG_DIR;;
        104)    echo "CONFIG: FAIL";;
        105)    echo "MAKE: FAIL";;
        106)    echo "CHECK: FAIL";;
        107)    echo "INSTALL: FAIL";;
        0)      [ $CHECK_PKG -eq 1 ] \
                    && echo "INSTALL: Succeed" \
                    || echo "INSTALL: Succeed (without CHECK)";;
    esac
}

time {
    install_flow > /tmp/build/lastbuild.log 2>&1
    RESULT=$?
    print_result $RESULT
    [ $RESULT -ne 0 ] && tail -n 10 /tmp/build/lastbuild.log
}

exit $RESULT
