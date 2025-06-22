#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl readline bash')

#https://ftp.gnu.org/gnu/gdbm/gdbm-1.25.tar.gz

export PACKAGE=gdbm-1.25
tar xf $SOURCES/gdbm-1.25.tar.gz && pushd $PACKAGE

sed -Ee "/#/s|(.*)|#include <sys/types.h>\n\1|;" -i tools/gdbmapp.h

./configure --prefix=/usr --disable-static --enable-libgdbm-compat

make

make check
## ------------- ##
## Test results. ##
## ------------- ##

## All 38 tests were successful.

make install

popd

rm -rf $PACKAGE
