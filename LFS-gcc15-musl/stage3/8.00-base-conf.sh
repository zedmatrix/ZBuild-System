#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#

export PACKAGE=
tar xf $SOURCES/ && pushd $PACKAGE

./configure --prefix=/usr --disable-static --with-curses \
            --docdir=/usr/share/doc/

make

make check

make install

popd

rm -rf $PACKAGE
