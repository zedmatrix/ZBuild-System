#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz
DEPENDS=(bash musl)

export PACKAGE=m4-1.4.20
tar xf $SOURCES/m4-1.4.20.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
##Testsuite summary for GNU M4 1.4.20
##============================================================================
# TOTAL: 366
# PASS:  308
# SKIP:  58
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0

make install

popd

rm -rf $PACKAGE
