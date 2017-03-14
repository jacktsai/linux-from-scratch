#!/bin/bash

# smart copy
function _scp() {
  local srcPath=$1
  if [ ! -e $srcPath ]; then
    for possiblePath in /bin /sbin /usr/bin /usr/sbin /lib /lib64 /usr/lib /usr/lib64
    do
      srcPath=$possiblePath/$1
      if [ -e $srcPath ]; then
        break
      fi
    done
  fi

  local targetPath=$LFS$srcPath

  if [ ! -e $srcPath ]; then
    printf "$1 not found.\n"
  else
    mkdir -p $(dirname $targetPath) 2> /dev/null
    cp -nv $srcPath $targetPath
    _dcp $srcPath
  fi
}

# copy dependency
function _dcp() {
    for deplib in $(readelf -d $1 | grep NEEDED | awk '{ print $5 }' | sed 's/\[//g' | sed 's/\]//g'); do
      _scp $deplib
    done
}

# clean directories
#for targetDir in /bin /sbin /usr/bin /usr/sbin /lib /lib64 /usr/lib /usr/lib64
#do
#    rm -rfv $LFS$targetDir
#done

_scp bash
_scp gcc
_scp gcc-config
_scp make
_scp ld
