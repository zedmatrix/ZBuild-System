#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Coreutils - 9.7

tar xf $SOURCES/coreutils-9.7.tar.xz && pushd coreutils-9.7

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) \
  --enable-install-program=hostname --enable-no-install-program=kill,uptime

make

make DESTDIR=$LFS install

mv -v $LFS/usr/bin/chroot $LFS/usr/sbin

mkdir -pv $LFS/usr/share/man/man8

mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $LFS/usr/share/man/man8/chroot.8

popd

rm -rf coreutils-9.7
