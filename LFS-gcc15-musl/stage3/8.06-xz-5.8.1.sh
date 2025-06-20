#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Xz - 5.8.1
# https://github.com//tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.xz

export PACKAGE=xz-5.8.1
tar xf $SOURCES/xz-5.8.1.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/xz-5.8.1

make

make check

make install

popd

rm -rf $PACKAGE
