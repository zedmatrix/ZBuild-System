#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl attr)

#https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.xz

export PACKAGE=acl-2.3.2
tar xf $SOURCES/acl-2.3.2.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
 --docdir=/usr/share/doc/acl-2.3.2

make

make check
# TOTAL: 15
# PASS:  7
# SKIP:  4
# XFAIL: 2
# FAIL:  2
# XPASS: 0
# ERROR: 0
## FAIL: test/misc.test
## FAIL: test/cp.test

make install

popd

rm -rf $PACKAGE
