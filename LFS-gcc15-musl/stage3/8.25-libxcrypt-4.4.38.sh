#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl')

#https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz

export PACKAGE=libxcrypt-4.4.38
tar xf $SOURCES/libxcrypt-4.4.38.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static --disable-failure-tokens \
  --enable-hashes=all --enable-obsolete-api=no

make

make check
# TOTAL: 43
# PASS:  42
# SKIP:  1
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0

make install

popd

rm -rf $PACKAGE
