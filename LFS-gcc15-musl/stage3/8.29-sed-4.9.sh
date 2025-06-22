#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('acl glibc|musl gettext')

#https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz

export PACKAGE=sed-4.9
tar xf $SOURCES/sed-4.9.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make && make html

chown -R tester .
su tester -c "PATH=$PATH make check"
## ============================================================================
## Testsuite summary for GNU sed 4.9
## ============================================================================
## # TOTAL: 192
## # PASS:  163
## # SKIP:  29
## # XFAIL: 0
## # FAIL:  0
## # XPASS: 0
## # ERROR: 0
## ============================================================================

make install

install -vdm755 /usr/share/doc/sed-4.9
install -vm644 doc/sed.html /usr/share/doc/sed-4.9

popd

rm -rf $PACKAGE
