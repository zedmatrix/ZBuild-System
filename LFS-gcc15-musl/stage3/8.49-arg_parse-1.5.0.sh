#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#git clone https://github.com/ericonr/argp-standalone.git arg_parse-1.5.0 ??

#tar xf $SOURCES/ && pushd $PACKAGE
pushd arg_parse-1.5.0

autoreconf -vif
CFLAGS="-fPIC" ./configure --prefix=/usr

make

make check
## PASS: ex1
## PASS: permute
## ==================
## All 2 tests passed
## ==================

cp -v argp.h /usr/include/argp.h
cp -v libargp.a /usr/lib/libargp.a

popd

rm -rf $PACKAGE

## https://github.com/void-linux/musl-fts/archive/refs/tags/v1.2.7.tar.gz
export PACKAGE=musl-fts-1.2.7
tar xf $SOURCES/musl-fts-v1.2.7.tar.gz && pushd $PACKAGE

./bootstrap.sh
./configure --prefix=/usr
make
make install

## Installed Directories: /usr/include  /usr/lib/pkgconfig  /usr/lib
## /usr/include/fts.h
## /usr/lib/pkgconfig/musl-fts.pc
## /usr/lib/libfts.a
## /usr/lib/libfts.la
## /usr/lib/libfts.so.0.0.0

popd

rm -rf $PACKAGE

## https://github.com/void-linux/musl-obstack/archive/refs/tags/v1.2.3.tar.gz
export PACKAGE=musl-obstack-1.2.3
tar xf $SOURCES/musl-obstack-v1.2.3.tar.gz && pushd $PACKAGE

./bootstrap.sh
./configure --prefix=/usr
make
make install

## Installed Files and Directories:
## /usr/lib/pkgconfig/musl-obstack.pc
## /usr/include/obstack.h
## /usr/lib/libobstack.la
## /usr/lib/libobstack.so.1.0.0
## /usr/lib/libobstack.a
## links: /usr/lib/libobstack.so{,.1}

popd

rm -rf $PACKAGE
