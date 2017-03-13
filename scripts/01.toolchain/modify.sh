#!/bin/bash

sed -e 's/cd \/tools\/work/cd \/tmp\/build/g' \
    -e 's/..\/src\//\/tools\/src\//'g \
    -e 's/> \/dev\/null//g' \
    -e 's/time build/time { build > \/tmp\/build\/lastbuild\.log; }/g' \
    new-script
