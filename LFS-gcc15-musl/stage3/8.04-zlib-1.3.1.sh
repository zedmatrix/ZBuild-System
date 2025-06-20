#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Zlib-1.3.1.tar.gz

export PACKAGE=zlib-1.3.1
tar xf $SOURCES/$PACKAGE.tar.gz && pushd $PACKAGE

./configure --prefix=/usr

make

make check

make install

popd

rm -rf $PACKAGE
