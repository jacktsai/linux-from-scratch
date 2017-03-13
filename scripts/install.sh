#!/bin/bash
if [ -e /etc/lfs-release ]; then
    [ $(id -u) -ne 0 ] && {
        echo "在 LFS 環境請使用 root 使用者執行."
        exit 1
    }
else
    [ $(id -u) -eq 0 ] && {
        echo "在非 LFS 環境請勿使用 root 使用者執行."
        exit 1
    }
fi

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
CHECK_PKG=0

# args=`getopt -l without-check -- "$@"`
# while true; do
#     case $1 in
#         --without-check)
#             CHECK_PKG=0
#             shift;;
#     esac
# done

function install() {
    cd $WORK_DIR
    rm -rf $PKG_DIR
    tar xf $SRC_DIR/$PKG_NAME
    cd $PKG_DIR

    config_pkg && {
        echo "[[[ config ok ]]]"
        build_pkg && {
            echo "[[[ build ok ]]]"
            if [ $CHECK_PKG -eq 1 ]; then
                check_pkg && CHECK_RESULT=0 || CHECK_RESULT=1
            else
                CHECK_RESULT=2
            fi

            [ $CHECK_RESULT -ne 1 ] && {
                install_pkg && {
                    echo "[[[ install ok ]]]"
                } || {
                    echo "[[[ install fail ]]]"
                }
            }
        } || {
            echo "[[[ build fail ]]]"
        }
    } || {
        echo "[[[ config fail ]]]"
    }
}

time {
    install > /tmp/build/lastbuild.log
    case $CHECK_RESULT in
        1) echo "[[[ check fail ]]]";;
        2) echo "[[[ check skipped ]]]";;
    esac
echo "[[[ check ok ]]]" || echo "[[[ check fail ]]]"
}
