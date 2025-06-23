#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz

export PACKAGE=libtasn1-4.20.0
tar xf $SOURCES/libtasn1-4.20.0.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --disable-static

make

make check
# Testsuite summary for GNU Libtasn1 4.20.0
# TOTAL: 31
# PASS:  31
# SKIP:  0
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0
# ============================================================================

make install

popd

rm -rf $PACKAGE
