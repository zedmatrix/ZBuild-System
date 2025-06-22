#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl')

#https://github.com/libexpat/libexpat/releases/download/R_2_7_1/expat-2.7.1.tar.xz

export PACKAGE=expat-2.7.1
tar xf $SOURCES/expat-2.7.1.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
  --docdir=/usr/share/doc/expat-2.7.1

make

make check
# ============================================================================
# Testsuite summary for expat 2.7.1
# TOTAL: 2
# PASS:  2

make install

# Optional Documentation
#install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.1

popd

rm -rf $PACKAGE
