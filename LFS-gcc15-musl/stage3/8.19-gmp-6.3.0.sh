#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl gcc-libs)

#https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz

export PACKAGE=gmp-6.3.0
tar xf $SOURCES/gmp-6.3.0.tar.xz && pushd $PACKAGE

sed -i '/long long t1;/,+1s/()/(...)/' configure

./configure --prefix=/usr --disable-static --enable-cxx \
            --docdir=/usr/share/doc/gmp-6.3.0

make && make html

make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
## 199

make install && make install-html

popd

rm -rf $PACKAGE
