#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc openssl xz zlib zstd meson libelf linux-headers')

#https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.xz

export PACKAGE=kmod-34.2
tar xf $SOURCES/kmod-34.2.tar.xz && pushd $PACKAGE

meson setup build  --prefix=/usr --buildtype=release -D manpages=false

meson compile -C build

meson install -C build

popd
rm -rf $PACKAGE
