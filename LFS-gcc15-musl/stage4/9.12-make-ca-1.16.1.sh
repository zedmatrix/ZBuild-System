#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/lfs-book/make-ca/archive/v1.16.1/make-ca-1.16.1.tar.gz

export PACKAGE=make-ca-1.16.1
tar xf $SOURCES/make-ca-1.16.1.tar.gz && pushd $PACKAGE

make install

install -vdm755 /etc/ssl/local

/usr/sbin/make-ca -g

popd

rm -rf $PACKAGE
