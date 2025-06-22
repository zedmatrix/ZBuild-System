#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('autoconf bash dejagnu expect gettext python gcc-fortran')

#https://ftp.gnu.org/gnu/automake/automake-1.18.tar.xz

export PACKAGE=automake-1.18
tar xf $SOURCES/automake-1.18.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18

make

# recommended -j4
make -j$(nproc) check
# ============================================================================
# Testsuite summary for GNU Automake 1.18
## TOTAL: 2960
## PASS:  2761
## SKIP:  160
## XFAIL: 39
## FAIL:  0
## XPASS: 0
## ERROR: 0

make install

popd

rm -rf $PACKAGE
