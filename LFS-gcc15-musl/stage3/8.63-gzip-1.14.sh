#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('bash coreutils glibc|musl grep sed diffutils less util-linux python')

#https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.xz

export PACKAGE=gzip-1.14
tar xf $SOURCES/gzip-1.14.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
# Testsuite summary for gzip 1.14
## TOTAL: 30
## PASS:  29
## SKIP:  1
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0
# ============================================================================

make install

popd
rm -rf $PACKAGE
