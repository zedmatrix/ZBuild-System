#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl gperf python texinfo')
#https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz

export PACKAGE=grep-3.12
tar xf $SOURCES/grep-3.12.tar.xz && pushd $PACKAGE

sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr

make

make check
# ============================================================================
# Testsuite summary for GNU grep 3.12
# ============================================================================
## TOTAL: 315
## PASS:  262
## SKIP:  53
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0

make install

popd

rm -rf $PACKAGE
