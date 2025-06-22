#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('awk diffutils m4 perl bash gcc-fortran')

#https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.xz

export PACKAGE=autoconf-2.72
tar xf $SOURCES/autoconf-2.72.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
## ------------- ##
## Test results. ##
## ------------- ##
## 549 tests behaved as expected.
## 60 tests were skipped.

make install

popd

rm -rf $PACKAGE
