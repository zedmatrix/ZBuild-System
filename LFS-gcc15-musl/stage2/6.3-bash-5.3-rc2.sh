#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Bash - 5.3-rc2

tar xf $SOURCES/bash-5.3-rc2.tar.gz && pushd bash-5.3-rc2

./configure --prefix=/usr --build=$(sh support/config.guess) --host=$LFS_TGT --without-bash-malloc

make

make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh

popd

rm -rf bash-5.3-rc2
