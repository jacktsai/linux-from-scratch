#!/bin/bash
[ $(id -u) -eq 0 ] && {
    echo "請不要使用 root 執行."
    exit 1
}

cd /tools/work
rm -rf perl-5.24.1
tar -xf ../src/perl-5.24.1.tar.bz2
cd perl-5.24.1

function build() {
sh Configure -des -Dprefix=/tools -Dlibs=-lm \
    && make > /dev/null \
    && cp perl cpan/podlators/scripts/pod2man /tools/bin \
    && mkdir -p /tools/lib/perl5/5.24.1 \
    && cp -R lib/* /tools/lib/perl5/5.24.1
}

time build
