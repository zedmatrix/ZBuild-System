#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# https://github.com/slicer69/sysvinit/releases/download/3.14/sysvinit-3.14.tar.xz
# https://www.linuxfromscratch.org/patches/lfs/development/sysvinit-3.14-consolidated-1.patch

export PACKAGE=sysvinit-3.14
tar xf $SOURCES/sysvinit-3.14.tar.xz && pushd $PACKAGE

patch -Np1 -i $SOURCES/sysvinit-3.14-consolidated-1.patch

make

make install

popd

rm -rf $PACKAGE
