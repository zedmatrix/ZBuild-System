#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('perl xml-parser')

#https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz

export PACKAGE=intltool-0.51.0
tar xf $SOURCES/intltool-0.51.0.tar.gz && pushd $PACKAGE

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make

make check
# ============================================================================
# Testsuite summary for intltool 0.51.0
## TOTAL: 1
## PASS:  1
## SKIP:  0
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0

make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

popd

rm -rf $PACKAGE
