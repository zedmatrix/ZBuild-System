#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Bison - 3.8.2

tar xf $SOURCES/bison-3.8.2.tar.xz && pushd bison-3.8.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make

make install

popd

rm -rf bison-3.8.2
