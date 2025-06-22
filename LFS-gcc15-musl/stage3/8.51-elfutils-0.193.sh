#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl gcc bash bzip2 xz zlib zstd')

#https://sourceware.org/ftp/elfutils/0.193/elfutils-0.193.tar.bz2

export PACKAGE=elfutils-0.193
tar xf $SOURCES/elfutils-0.193.tar.bz2 && pushd $PACKAGE

patch -Np1 -i ../elfutils-musl-macros.patch

./configure --prefix=/usr --disable-debuginfod --enable-libdebuginfod=dummy

make

make check
## FAIL: dwarf_srclang_check

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig

## Optional to remove
# rm /usr/lib/libelf.a

popd

rm -rf $PACKAGE
