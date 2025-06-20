#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# M4 - 1.4.20

tar -xf $SOURCES/m4-1.4.20.tar.xz && pushd m4-1.4.20

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf m4-1.4.20
