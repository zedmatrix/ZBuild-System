#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
# Binutils-2.44 pass 1

tar xf $SOURCES/binutils-2.44.tar.xz && pushd binutils-2.44

mkdir -v build && cd build

../configure --prefix=$LFS/tools --with-sysroot=$LFS --target=$LFS_TGT --disable-nls \
 --disable-werror --enable-gprofng=no --enable-new-dtags

make

make install

popd
rm -rf binutils-2.44
