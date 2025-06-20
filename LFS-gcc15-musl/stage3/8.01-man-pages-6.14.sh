#!/bin/bash
export SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Man-pages-6.14

export PACKAGE=man-pages-6.14
tar xf $SOURCES/$PACKAGE.tar.xz && pushd $PACKAGE

rm -v man3/crypt*

make -R GIT=false prefix=/usr install

popd

rm -rf $PACKAGE
