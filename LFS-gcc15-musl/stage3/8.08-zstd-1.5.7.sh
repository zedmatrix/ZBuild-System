#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz

export PACKAGE=zstd-1.5.7
tar xf $SOURCES/zstd-1.5.7.tar.gz && pushd $PACKAGE

make prefix=/usr

make check

## Skipping large data tests
## \n******************************
## All tests completed successfully
## ******************************

make prefix=/usr install

rm -v /usr/lib/libzstd.a

popd

rm -rf $PACKAGE
