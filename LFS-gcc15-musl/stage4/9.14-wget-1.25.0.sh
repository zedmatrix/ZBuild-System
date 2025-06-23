#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('libpsl p11-kit make-ca')

#https://ftp.gnu.org/gnu/wget/wget-1.25.0.tar.gz

export PACKAGE=wget-1.25.0
tar xf $SOURCES/wget-1.25.0.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --sysconfdir=/etc --with-ssl=openssl

make

make check
# ============================================================================
# Testsuite summary for wget 1.25.0
## TOTAL: 88
## PASS:  15
## SKIP:  14
## XFAIL: 0
## FAIL:  59
## XPASS: 0
## ERROR: 0
# ============================================================================
## Missing testsuite programs: http-daemon io-socket-ssl valgrind

make install

popd
rm -rf $PACKAGE
