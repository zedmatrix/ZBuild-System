#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Binutils - 2.44 - Pass 2

tar xf $SOURCES/binutils-2.44.tar.xz && pushd binutils-2.44

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build && cd build

../configure --prefix=/usr --build=$(../config.guess) --host=$LFS_TGT --disable-nls --enable-shared \
  --enable-gprofng=no --disable-werror --enable-64-bit-bfd --enable-new-dtags

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

popd

rm -rf binutils-2.44
