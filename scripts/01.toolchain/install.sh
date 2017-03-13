#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

[ $# -lt 1 ] && {
    printf 'Usage: %s [module name]\n' $(basename $0)
    exit 0
}

MODULE=$1

[ ! -e $MODULE ] && {
    printf 'Module "%s" Not Found !!\n' $MODULE
    exit 0
}

# 載入模組並設定變數
source $MODULE
SRC_DIR='/tools/src'
WORK_DIR='/tmp/build'
PKG_NAME=$(tar_name)
PKG_DIR=$(tar_dir)
CHECK_PKG=1

args=`getopt -l without-check -- "$@"`
while true; do
    case $1 in
        --without-check)
            CHECK_PKG=0
            shift;;
    esac
done

config_pkg
[ $? -eq 0 ] && {
    echo config ok
    build_pkg
    [ $? -eq 0 ] && {
        echo build ok
echo CHECK_PKG = $CHECK_PKG
        CHECK_RESULT=0
        if [[ CHECK_PKG -eq 1 ]]; then
            check_pkg
            CHECK_RESULT=$?
        fi
echo CHECK_RESULT = $CHECK_RESULT
        [[ CHECK_RESULT -eq '0' ]] && {
            echo check ok
            install_pkg
            [ $? -eq 0 ] && {
                echo install ok
            } || {
                echo install fail
            }
        } || {
            echo check fail
        }
    } || {
        echo build fail
    }
} || {
    echo config fail
}

function process() {
    cd /tmp/build
    rm -rf $PKG_DIR
    tar xf /tools/src/$PKG_NAME
    cd $PKG_DIR
}
