#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/libarchive/libarchive/releases/download/v3.8.1/libarchive-3.8.1.tar.xz

export PACKAGE=libarchive-3.8.1
tar xf $SOURCES/libarchive-3.8.1.tar.xz && pushd $PACKAGE

./configure --prefix=/usr #--disable-static

make

make check
# ============================================================================
# Testsuite summary for libarchive 3.8.1
# TOTAL: 5
# PASS:  4
# SKIP:  0
# XFAIL: 0
# FAIL:  1
# FAIL: libarchive_test

./libarchive_test -v
# Totals:
#   Tests run:              683
#   Tests failed:            58
#   Assertions checked:32053579
#   Assertions failed:      132
#   Skips reported:          60


make install
ln -sfv bsdunzip /usr/bin/unzip

popd

rm -rf $PACKAGE
