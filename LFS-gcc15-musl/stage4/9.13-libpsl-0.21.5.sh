#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz

export PACKAGE=libpsl-0.21.5
tar xf $SOURCES/libpsl-0.21.5.tar.gz && pushd $PACKAGE

meson setup build --prefix=/usr --buildtype=release

meson compile -C build

meson test -C build
# Ok:                8
# Fail:              0

meson install -C build

popd

rm -rf $PACKAGE
