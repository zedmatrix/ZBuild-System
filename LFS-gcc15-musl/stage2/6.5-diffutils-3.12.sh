#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Diffutils - 3.12

tar xf $SOURCES/diffutils-3.12.tar.xz && pushd diffutils-3.12

./configure --prefix=/usr --host=$LFS_TGT --build=$(./build-aux/config.guess) gl_cv_func_strcasecmp_works=y

make

make DESTDIR=$LFS install

popd

rm -rf diffutils-3.12
