#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('bash glibc|musl gperf help2man python')

#https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz

export PACKAGE=diffutils-3.12
tar xf $SOURCES/diffutils-3.12.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
# ============================================================================
# Testsuite summary for GNU diffutils 3.12
#
## TOTAL: 344
## PASS:  277
## SKIP:  67
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0
# ============================================================================

make install

popd
rm -rf $PACKAGE
