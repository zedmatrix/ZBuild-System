#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(binutils gcc-libs mpc zstd libc)

#https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz

export PACKAGE=gcc-15.1.0
tar xf $SOURCES/gcc-15.1.0.tar.xz && pushd $PACKAGE

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build && cd build

../configure --prefix=/usr LD=ld --enable-languages=c,c++ \
  --enable-default-pie --enable-default-ssp --enable-host-pie \
  --disable-multilib --disable-bootstrap --disable-fixincludes \
  --with-system-zlib

make

ulimit -s -H unlimited
sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
sed -e 's/no-pic /&-no-pie /' -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
sed -e 's/300000/(1|300000)/' -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
sed -e 's/{ target nonpic } //' -e '/GOTPCREL/d' -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
chown -R tester .
su tester -c "PATH=$PATH make -k check"

../contrib/test_summary | grep -A7 Summ


make install
chown -v -R root:root /usr/lib/gcc/$(gcc -dumpmachine)/15.1.0/include{,-fixed}
ln -svr /usr/bin/cpp /usr/lib
ln -sv gcc.1 /usr/share/man/man1/cc.1
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.1.0/liblto_plugin.so /usr/lib/bfd-plugins/

## Testsuite
echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
## [Requesting program interpreter: /lib/ld-musl-x86_64.so.1]

grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
## /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/Scrt1.o succeeded
## /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/crti.o succeeded
## /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/crtn.o succeeded

grep -B4 '^ /usr/include' dummy.log
## ignoring nonexistent directory "/usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../x86_64-pc-linux-musl/include"
## #include "..." search starts here:
## #include <...> search starts here:
##  /usr/local/include
##  /usr/include

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# # SEARCH_DIR("/usr/x86_64-pc-linux-musl/lib64")
# # SEARCH_DIR("/usr/local/lib64")
# # SEARCH_DIR("/lib64")
# # SEARCH_DIR("/usr/lib64")
# # SEARCH_DIR("/usr/x86_64-pc-linux-musl/lib")
# # SEARCH_DIR("/usr/local/lib")
# # SEARCH_DIR("/lib")
# # SEARCH_DIR("/usr/lib");

grep "/lib.*/*.so* " dummy.log ## grep "/lib.*/libc.so.6 " dummy.log
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc_s.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/libgcc_s.so succeeded
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libc.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/libc.so succeeded
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc_s.so failed
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/../../../../lib/libgcc_s.so succeeded
# # attempt to open /usr/lib/gcc/x86_64-pc-linux-musl/15.1.0/libgcc.so failed

grep found dummy.log ##?? none

ldd a.out
# #         /lib/ld-musl-x86_64.so.1 (0x7feced800000)
# #         libc.so => /lib/ld-musl-x86_64.so.1 (0x7feced800000)

## Finalize
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib


popd

rm -rf $PACKAGE
