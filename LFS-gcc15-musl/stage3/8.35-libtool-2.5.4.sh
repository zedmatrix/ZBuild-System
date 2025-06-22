#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl bash tar gcc')

#https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz

export PACKAGE=libtool-2.5.4
tar xf $SOURCES/libtool-2.5.4.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
## ============================================================================
## Testsuite summary for GNU Libtool 2.5.4
## ============================================================================
## # TOTAL: 6
## # PASS:  4
## # SKIP:  2
## # XFAIL: 0
## # FAIL:  0
## # XPASS: 0
## # ERROR: 0
## ============================================================================

make install

# optional probably should not
#rm -fv /usr/lib/libltdl.a

popd

rm -rf $PACKAGE
