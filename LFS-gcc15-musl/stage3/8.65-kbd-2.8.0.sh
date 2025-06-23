#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl gzip')

#https://www.kernel.org/pub/linux/utils/kbd/kbd-2.8.0.tar.xz
#https://www.linuxfromscratch.org/patches/lfs/development/kbd-2.8.0-backspace-1.patch

export PACKAGE=kbd-2.8.0
tar xf $SOURCES/kbd-2.8.0.tar.xz && pushd $PACKAGE

patch -Np1 -i $SOURCES/kbd-2.8.0-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make install

## Optional Documentation
# cp -R -v docs/doc -T /usr/share/doc/kbd-2.8.0

popd
rm -rf $PACKAGE
