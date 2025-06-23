#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl dejagnu')

#https://github.com/libffi/libffi/releases/download/v3.5.1/libffi-3.5.1.tar.gz

export PACKAGE=libffi-3.5.1
tar xf $SOURCES/libffi-3.5.1.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --with-gcc-arch=native

make

make check
## === libffi Summary ===
## of expected passes            2460

make install

popd

rm -rf $PACKAGE
