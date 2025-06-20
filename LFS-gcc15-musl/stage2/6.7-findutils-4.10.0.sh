#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Findutils - 4.10.0

tar xf $SOURCES/findutils-4.10.0.tar.xz && pushd findutils-4.10.0

./configure --prefix=/usr --localstatedir=/var/lib/locate --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf findutils-4.10.0
