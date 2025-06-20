#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz

export PACKAGE=lz4-1.10.0
tar xf $SOURCES/lz4-1.10.0.tar.gz && pushd $PACKAGE

make BUILD_STATIC=no PREFIX=/usr

make -j1 check

make BUILD_STATIC=no PREFIX=/usr install

popd

rm -rf $PACKAGE
