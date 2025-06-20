#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Gawk - 5.3.2

tar xf $SOURCES/gawk-5.3.2.tar.xz && pushd gawk-5.3.2

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf gawk-5.3.2
