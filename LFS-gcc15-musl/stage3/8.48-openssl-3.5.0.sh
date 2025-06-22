#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl perl ca-certs')

#https://github.com/openssl/openssl/releases/download/openssl-3.5.0/openssl-3.5.0.tar.gz

export PACKAGE=openssl-3.5.0
tar xf $SOURCES/openssl-3.5.0.tar.gz && pushd $PACKAGE

## note config is a wrapper for Configure
./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic

make

HARNESS_JOBS=$(nproc) make test
## All tests successful.
## Files=342, Tests=4460, 156 wallclock secs
## Result: PASS

## Optional to remove static libs
#sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.5.0

## Optional to install additional documents
#cp -vfr doc/* /usr/share/doc/openssl-3.5.0

popd

rm -rf $PACKAGE
