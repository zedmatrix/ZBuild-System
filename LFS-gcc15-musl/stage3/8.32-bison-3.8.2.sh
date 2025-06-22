#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gettext glibc|musl m4 bash')

#https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz

export PACKAGE=bison-3.8.2
tar xf $SOURCES/bison-3.8.2.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make

make check
## ------------- ##
## Test results. ##
## ------------- ##
# 696 tests were successful.
# 80 tests were skipped.

make install

popd

rm -rf $PACKAGE
