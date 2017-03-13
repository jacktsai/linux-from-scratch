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
CONFIG_RESULT=-1
MAKE_RESULT=-1
CHECK_RESULT=-1
INSTALL_RESULT=-1

# args=`getopt -l without-check -- "$@"`
# while true; do
#     case $1 in
#         --without-check)
#             CHECK_PKG=0
#             shift;;
#     esac
# done

function install() {
    [ ! -e $WORK_DIR ] && {
        printf 'WORK_DIR "%s" Not Found !!\n' $WORK_DIR
        return 1
    }

    cd $WORK_DIR
    [ -e $PKG_DIR ] && rm -rf $PKG_DIR

    if [ -e $SRC_DIR/$PKG_NAME ]; then
        tar xf $SRC_DIR/$PKG_NAME
    else
        printf 'Package "%s" Not Found !!\n' $SRC_DIR/$PKG_NAME
        return 1
    fi

    [ -e $PKG_DIR ] && cd $PKG_DIR || {
        printf 'Directory "%s" Not Found !!\n' $PKG_DIR
        return 1
    }

    config_pkg && {
        CONFIG_RESULT=0
        make_pkg && {
            MAKE_RESULT=0

            if [ $CHECK_PKG -eq 1 ]; then
                check_pkg && CHECK_RESULT=0 || CHECK_RESULT=1
            else
                CHECK_RESULT=2
            fi

            [ $CHECK_RESULT -ne 1 ] && {
                install_pkg && INSTALL_RESULT=0 || INSTALL_RESULT=1
            }
        } || MAKE_RESULT=1
    } || CONFIG_RESULT=1
}

function print_result() {
    case $CONFIG_RESULT in
        0) echo "CONFIG: Succeed"
            case $MAKE_RESULT in
                0) echo "MAKE: Succeed"
                    case $CHECK_RESULT in
                        0) echo "CHECK: Succeed";;
                        1) echo "CHECK: FAIL"
                            return 3
                            ;;
                        2) echo "CHECK: skipped";;
                    esac
                    case $INSTALL_RESULT in
                        0) echo "INSTALL: Succeed"
                            return 0
                            ;;
                        1) echo "INSTALL: FAIL"
                            return 4
                            ;;
                    esac
                    ;;
                1) echo "MAKE: FAIL"
                    return 2
                    ;;
            esac
            ;;
        1) echo "CONFIG: FAIL"
            return 1
            ;;
    esac
}

time {
    install > /tmp/build/lastbuild.log 2>&1 \
    && {
        print_result || tail -n 10 /tmp/build/lastbuild.log
    } || tail /tmp/build/lastbuild.log
}
