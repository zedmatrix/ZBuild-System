#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Libstdc++ from GCC-15.1.0

tar -xf $SOURCES/gcc-15.1.0.tar.xz && pushd gcc-15.1.0

mkdir -v build && cd build

../libstdc++-v3/configure --host=$LFS_TGT --build=$(../config.guess) --prefix=/usr \
  --disable-multilib --disable-nls --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.1.0

make

make DESTDIR=$LFS install

popd

rm -rf gcc-15.1.0
