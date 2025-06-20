#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Make - 4.4.1

tar xf $LFS/sources/make-4.4.1.tar.gz && pushd make-4.4.1

sed -i '/^extern char \*getenv *()/d' lib/fnmatch.c
sed -i '/^extern char \*getenv *()/d' src/getopt.c
sed -i '/#  include <string.h>/a #include <stdlib.h>' src/getopt.c
sed -i 's/^extern int getopt *(.*);$/extern int getopt (int, char * const *, const char *);/' src/getopt.h

./configure --prefix=/usr --without-guile --host=$LFS_TGT --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

popd

rm -rf make-4.4.1
