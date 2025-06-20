#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl gmp)

#https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz

export PACKAGE=mpfr-4.2.2
tar xf $SOURCES/mpfr-4.2.2.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static --enable-thread-safe \
  --docdir=/usr/share/doc/mpfr-4.2.2

make && make html

make check 2>&1 | tee mpfr-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' mpfr-check-log
# 198

make install && make install-html

popd

rm -rf $PACKAGE
