#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('ncurses')

#https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.7.tar.xz

export PACKAGE=psmisc-23.7
tar xf $SOURCES/psmisc-23.7.tar.xz && pushd $PACKAGE

./configure --prefix=/usr &&

make

make check

make install

popd

rm -rf $PACKAGE
