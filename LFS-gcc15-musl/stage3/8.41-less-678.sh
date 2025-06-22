#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl ncurses pcre2')

#https://www.greenwoodsoftware.com/less/less-678.tar.gz

export PACKAGE=less-678
tar xf $SOURCES/less-678.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --sysconfdir=/etc --with-regex=pcre2

make

make check
## RAN  17 tests with 0 errors

make install

popd

rm -rf $PACKAGE
