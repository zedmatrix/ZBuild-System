#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Texinfo - 7.2

tar xf $SOURCES/texinfo-7.2.tar.xz && pushd texinfo-7.2

./configure --prefix=/usr

make

make install

popd

rm -rf texinfo-7.2
