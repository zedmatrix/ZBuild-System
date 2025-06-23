#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl ncurses gettext')

#https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.5.tar.xz

export PACKAGE=procps-ng-4.0.5
bsdtar xf $SOURCES/procps-ng-4.0.5.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static --disable-kill --enable-watch8bit \
  --without-systemd --without-elogind --docdir=/usr/share/doc/procps-ng-4.0.5

make

chown -R tester .
su tester -c "PATH=$PATH make check"
# TOTAL: 8
# PASS:  8

make install

popd

rm -rf $PACKAGE
