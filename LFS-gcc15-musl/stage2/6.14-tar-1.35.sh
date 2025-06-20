#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Tar - 1.35

tar xf $SOURCES/tar-1.35.tar.xz && pushd tar-1.35

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf tar-1.35
