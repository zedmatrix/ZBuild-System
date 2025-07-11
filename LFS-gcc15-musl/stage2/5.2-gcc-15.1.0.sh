#!/bin/bash
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
# 1.3 - GCC-15.1.0 pass 1

tar -xf $SOURCES/gcc-15.1.0.tar.xz && pushd gcc-15.1.0

tar -xf $SOURCES/gmp-6.3.0.tar.xz && mv -v gmp-6.3.0 gmp
tar -xf $SOURCES/mpfr-4.2.2.tar.xz && mv -v mpfr-4.2.2 mpfr
tar -xf $SOURCES/mpc-1.3.1.tar.gz && mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build && cd build

../configure --target=$LFS_TGT --prefix=$LFS/tools --with-glibc-version=2.41 --with-sysroot=$LFS --with-newlib \
  --without-headers --enable-default-pie --enable-default-ssp --disable-nls --disable-shared --disable-multilib \
  --disable-threads --disable-libatomic --disable-libgomp --disable-libquadmath --disable-libssp --disable-libvtv \
  --disable-libstdcxx --enable-languages=c,c++

make
make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

popd
rm -rf gcc-15.1.0
