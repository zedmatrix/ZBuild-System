#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Python - 3.13.5

tar xf $SOURCES/Python-3.13.5.tar.xz && pushd Python-3.13.5

./configure --prefix=/usr --enable-shared --without-ensurepip \
 --without-static-libpython --disable-test-modules

make

make install

popd

rm -rf Python-3.13.5
