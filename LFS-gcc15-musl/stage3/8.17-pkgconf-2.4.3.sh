#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl bash)

#https://distfiles.ariadne.space/pkgconf/pkgconf-2.4.3.tar.xz

export PACKAGE=pkgconf-2.4.3
tar xf $SOURCES/pkgconf-2.4.3.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
 --docdir=/usr/share/doc/pkgconf-2.4.3

make

make install

ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

popd

rm -rf $PACKAGE
