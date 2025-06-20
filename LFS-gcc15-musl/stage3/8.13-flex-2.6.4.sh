#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
#DEPENDS=(glibc|musl m4 bash perl|help2man)

export PACKAGE=flex-2.6.4
tar xf $SOURCES/flex-2.6.4.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
  --docdir=/usr/share/doc/flex-2.6.4

make

make check
## Testsuite summary for the fast lexical analyser generator 2.6.4
## ============================================================================
# TOTAL: 114
# PASS:  114
# SKIP:  0
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0

make install

ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

popd

rm -rf $PACKAGE
