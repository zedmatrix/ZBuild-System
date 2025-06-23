#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl bash python')

#https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz

export PACKAGE=findutils-4.10.0
tar xf $SOURCES/findutils-4.10.0.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --localstatedir=/var/lib/locate

make

chown -R tester .
su tester -c "PATH=$PATH make check"
# ============================================================================
# Testsuite summary for GNU findutils 4.10.0
## TOTAL: 362
## PASS:  302
## SKIP:  60
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0

# make[2]: Entering directory '/zbuild/findutils-4.10.0'
#   CC       tests/xargs/test-sigusr.o
# tests/xargs/test-sigusr.c:34:10: fatal error: error.h: No such file or directory
#    34 | #include <error.h>
#       |          ^~~~~~~~~
# compilation terminated.
# make[2]: *** [Makefile:2809: tests/xargs/test-sigusr.o] Error 1
# make[2]: Leaving directory '/zbuild/findutils-4.10.0'
# make[1]: *** [Makefile:3306: check-am] Error 2
# make[1]: Leaving directory '/zbuild/findutils-4.10.0'
# make: *** [Makefile:2831: check-recursive] Error 1

make install

popd
rm -rf $PACKAGE
