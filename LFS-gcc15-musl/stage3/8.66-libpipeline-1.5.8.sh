#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl')

#https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz

export PACKAGE=libpipeline-1.5.8
tar xf $SOURCES/libpipeline-1.5.8.tar.gz && pushd $PACKAGE

./configure --prefix=/usr

make

make install

popd
rm -rf $PACKAGE
