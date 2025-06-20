#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl gmp mpfr)

#https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz

export PACKAGE=mpc-1.3.1
tar xf $SOURCES/mpc-1.3.1.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
  --docdir=/usr/share/doc/mpc-1.3.1

make && make html

make check 2>&1 | tee mpc-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' mpc-check-log
# 74

make install && make install-html

popd

rm -rf $PACKAGE
