#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Xz-5.8.1

tar xf $SOURCES/xz-5.8.1.tar.xz && pushd xz-5.8.1

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) \
  --disable-static --docdir=/usr/share/doc/xz-5.8.1

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la

popd

rm -rf xz-5.8.1
