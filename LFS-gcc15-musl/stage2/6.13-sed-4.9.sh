#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Sed - 4.9

tar xf $SOURCES/sed-4.9.tar.xz && pushd sed-4.9

./configure --prefix=/usr --host=$LFS_TGT --build=$(./build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf sed-4.9
