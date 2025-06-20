#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# https://astron.com/pub/file/file-5.46.tar.gz

export PACKAGE=file-5.46
tar xf $SOURCES/file-5.46.tar.gz && pushd $PACKAGE

./configure --prefix=/usr

make

make check

make install

popd

rm -rf $PACKAGE
