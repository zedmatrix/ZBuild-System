#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
# Linux - 6.6.93

tar xf $SOURCES/linux-6.6.93.tar.xz && pushd linux-6.6.93

make mrproper &&

make headers

find usr/include -type f ! -name '*.h' -delete

cp -rv usr/include $LFS/usr

popd

rm -rf linux-6.6.93
