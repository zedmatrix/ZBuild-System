#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl libelf zlib zstd bc dejagnu)

#https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz

export PACKAGE=binutils-2.44
tar xf $SOURCES/binutils-2.44.tar.xz && pushd $PACKAGE

mkdir -v build && cd build

../configure --prefix=/usr --sysconfdir=/etc --enable-ld=default \
  --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd \
  --enable-new-dtags --with-system-zlib

make tooldir=/usr

make -k check
## === ld Summary ===
# of expected passes            2940
# of unexpected failures        15
# of unexpected successes       4
# of expected failures          60
# of untested testcases         1
# of unsupported tests          51
grep '^FAIL:' $(find -name '*.log') || echo "true"
# ./ld/ld.log:FAIL: preinit array
# ./ld/ld.log:FAIL: PIE preinit array
# ./ld/ld.log:FAIL: Static PIE preinit array
# ./ld/ld.log:FAIL: static preinit array
# ./ld/ld.log:FAIL: Run with libpr19553c.so
# ./ld/ld.log:FAIL: Run pr25749-1bb (-no-pie -fno-PIE)
# ./ld/ld.log:FAIL: Run pr25749-1bb (-pie -fPIE)
# ./ld/ld.log:FAIL: Run pr25749-2ab (-no-pie -fno-PIE)
# ./ld/ld.log:FAIL: Run pr25749-2ab (-pie -fPIE)
# ./ld/ld.log:FAIL: Run pr2404
# ./ld/ld.log:FAIL: Run pr2404n
# ./ld/ld.log:FAIL: pr26580-4
# ./ld/ld.log:FAIL: Run pr2404 with PIE
# ./ld/ld.log:FAIL: Run pr2404 with PIE (-z now)
# ./ld/ld.log:FAIL: vers16

make tooldir=/usr install

rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a /usr/share/doc/gprofng/

# ls -l /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.*
popd

rm -rf $PACKAGE
