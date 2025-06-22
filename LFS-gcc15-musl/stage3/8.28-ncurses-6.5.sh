#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gcc-libs glibc|musl bash')
#https://invisible-mirror.net/archives/ncurses/current/ncurses-6.5-20250531.tgz

export PACKAGE=ncurses-6.5
mkdir -v $PACKAGE &&
tar xf $SOURCES/ncurses-6.5-20250531.tgz -C $PACKAGE \
 --strip-components=1 && pushd $PACKAGE

./configure --prefix=/usr --mandir=/usr/share/man --with-shared --with-cxx-shared \
  --without-debug --without-normal--enable-pc-files --with-pkg-config-libdir=/usr/lib/pkgconfig

make

make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
rm -v  dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i dest/usr/include/curses.h
cp -av dest/* /

for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done

ln -sfv libncursesw.so /usr/lib/libcurses.so

## Optional Install Documentation
# cp -v -R doc -T /usr/share/doc/ncurses-6.5-20250531

## Non-Wide Character
make distclean
./configure --prefix=/usr --with-shared --without-normal \
  --without-debug --without-cxx-binding --with-abi-version=5
make sources libs
cp -av lib/lib*.so.5* /usr/lib


popd

rm -rf $PACKAGE
