#!/bin/bash
SRC_DIR='/tools/src'
WORK_DIR='/tmp/build'

source binutils-cross.sh

$1 $2
