#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Grep - 3.12

tar xf $SOURCES/grep-3.12.tar.xz && pushd grep-3.12

./configure --prefix=/usr --host=$LFS_TGT --build=$(./build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf grep-3.12
