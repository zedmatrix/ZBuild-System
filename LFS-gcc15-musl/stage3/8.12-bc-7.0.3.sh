#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz
DEPENDS=(readline)

export PACKAGE=bc-7.0.3
tar xf $SOURCES/bc-7.0.3.tar.xz && pushd $PACKAGE

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make

make test
## All dc tests passed.
## All bc tests passed.

make install

popd

rm -rf $PACKAGE
