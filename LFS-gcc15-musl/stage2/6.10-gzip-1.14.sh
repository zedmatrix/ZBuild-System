#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Gzip - 1.14

tar xf $SOURCES/gzip-1.14.tar.xz && pushd gzip-1.14

./configure --prefix=/usr --host=$LFS_TGT

make

make DESTDIR=$LFS install

popd

rm -rf gzip-1.14
