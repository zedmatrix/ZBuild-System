#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl gcc-libs')

#https://ftp.gnu.org/gnu/gperf/gperf-3.3.tar.gz

export PACKAGE=gperf-3.3
tar xf $SOURCES/gperf-3.3.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3

make

make check

make install

popd

rm -rf $PACKAGE
