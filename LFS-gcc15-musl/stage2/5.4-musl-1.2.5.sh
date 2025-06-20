#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Musl - 1.2.5

tar xf $SOURCES/musl-1.2.5.tar.gz && pushd musl-1.2.5

ln -sfv ../lib/ld-musl-x86_64.so.1 $LFS/lib64
ln -sfv ../lib/ld-musl-x86_64.so.1 $LFS/lib64/ld-lsb-x86-64.so.3

./configure --prefix=/usr --target=$LFS_TGT --build=x86_64-pc-linux-gnu

make

make DESTDIR=$LFS install

ln -sfv ../lib/ld-musl-x86_64.so.1 /usr/bin/ldd

echo 'int main(){}' | $LFS_TGT-gcc -xc -
readelf -l a.out | grep ld-musl

# output: [Requesting program interpreter: /lib/ld-musl-x86_64.so.1]

popd
rm -rf musl-1.2.5
