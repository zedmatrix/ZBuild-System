#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Patch - 2.8

tar xf $SOURCES/patch-2.8.tar.xz && pushd patch-2.8

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf patch-2.8
