#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(glibc|musl gettext)

#https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz

export PACKAGE=attr-2.5.2
tar xf $SOURCES/attr-2.5.2.tar.gz && pushd $PACKAGE

sed -Ee "1s|(.*)|#include <libgen.h>\n\1|;" -i tools/attr.c

./configure --prefix=/usr --disable-static \
 --sysconfdir=/etc --docdir=/usr/share/doc/attr-2.5.2

make

make check
# PASS: test/root/getfattr.test
# FAIL: test/attr.test
# TOTAL: 2
# PASS:  1
# SKIP:  0
# XFAIL: 0
# FAIL:  1
# XPASS: 0
# ERROR: 0

make install

popd

rm -rf $PACKAGE
