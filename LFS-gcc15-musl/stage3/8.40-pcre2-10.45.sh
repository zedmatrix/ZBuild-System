#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('bzip2 bash glibc|musl readline zlib')

#https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.tar.bz2

export PACKAGE=pcre2-10.45
tar xf $SOURCES/pcre2-10.45.tar.bz2 && pushd $PACKAGE

./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/pcre2-10.45 \
 --enable-unicode --enable-jit --enable-pcre2-16 --enable-pcre2-32 \
 --enable-pcre2grep-libz --enable-pcre2grep-libbz2 --enable-pcre2test-libreadline

make

make check
## Testsuite summary for PCRE2 10.45
# TOTAL: 4
# PASS:  4
# SKIP:  0
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0

make install

popd

rm -rf $PACKAGE
