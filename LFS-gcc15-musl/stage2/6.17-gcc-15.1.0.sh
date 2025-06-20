#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# GCC-15.1.0 - Pass 2

tar xf $SOURCES/gcc-15.1.0.tar.xz && pushd gcc-15.1.0

tar -xf $SOURCES/gmp-6.3.0.tar.xz && mv -v gmp-6.3.0 gmp
tar -xf $SOURCES/mpfr-4.2.2.tar.xz && mv -v mpfr-4.2.2 mpfr
tar -xf $SOURCES/mpc-1.3.1.tar.gz && mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

sed '/thread_header =/s/@.*@/gthr-posix.h/' -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build && cd build

../configure --build=$(../config.guess) --host=$LFS_TGT --target=$LFS_TGT \
   LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc --prefix=/usr --with-build-sysroot=$LFS \
   --enable-default-pie --enable-default-ssp --disable-nls --disable-multilib --disable-libatomic \
   --disable-libgomp --disable-libquadmath --disable-libsanitizer --disable-libssp \
   --disable-libvtv --enable-languages=c,c++

make

make DESTDIR=$LFS install

ln -sv gcc $LFS/usr/bin/cc

popd

rm -rf gcc-15.1.0
