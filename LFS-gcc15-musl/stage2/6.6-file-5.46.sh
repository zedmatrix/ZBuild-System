#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# File - 5.46

tar xf $LFS/sources/file-5.46.tar.gz && pushd file-5.46

mkdir -v build && pushd build
  ../configure --disable-bzlib --disable-libseccomp --disable-xzlib --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/libmagic.la

popd

rm -rf file-5.46
