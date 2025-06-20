#!/bin/bash
export SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Iana-Etc-20250519

export PACKAGE=Iana-Etc-20250519
tar xf $SOURCES/$PACKAGE.tar.xz && pushd $PACKAGE

rm -v man3/crypt*

make -R GIT=false prefix=/usr install

popd

rm -rf $PACKAGE
