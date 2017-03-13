

function binutils-cross() {

PACKAGE_NAME='binutils-2.27.tar.bz2'
FOLDER_NAME='binutils-2.27'

cd /tools/work
rm -rf binutils-2.27
tar -xf ../src/binutils-2.27.tar.bz2
cd binutils-2.27

./configure \
    --prefix=/tools            \
    --with-sysroot=$LFS        \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT          \
    --disable-nls              \
    --disable-werror           \
    > /dev/null                \
    && make > /dev/null        \
    && mkdir /tools/lib && ln -s lib /tools/lib64 \
    && make install > /dev/null
}
