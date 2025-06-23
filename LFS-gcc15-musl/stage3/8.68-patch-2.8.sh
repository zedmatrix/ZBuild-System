#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('attr glibc|musl python')

#https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz

export PACKAGE=patch-2.8
tar xf $SOURCES/patch-2.8.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
##Testsuite summary for GNU patch 2.8
# ============================================================================
## TOTAL: 49
## PASS:  45
## SKIP:  2
## XFAIL: 2
## FAIL:  0
## XPASS: 0
## ERROR: 0

make install

popd

rm -rf $PACKAGE
