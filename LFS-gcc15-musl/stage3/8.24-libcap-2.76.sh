#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl linux-api-headers')

#https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.76.tar.xz

export PACKAGE=libcap-2.76
tar xf $SOURCES/libcap-2.76.tar.xz && pushd $PACKAGE

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

make test

make prefix=/usr lib=lib install

popd

rm -rf $PACKAGE
