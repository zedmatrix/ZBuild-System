#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Ncurses - 6.5

tar xf $SOURCES/ncurses-6.5.tar.gz && pushd ncurses-6.5

mkdir -v build && pushd build
  ../configure AWK=gawk
  make -C include &&
  make -C progs tic
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess) --mandir=/usr/share/man \
  --with-manpage-format=normal --with-shared --without-normal --with-cxx-shared --without-debug \
  --without-ada --disable-stripping AWK=gawk

make

make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install

ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h

popd

rm -rf ncurses-6.5
