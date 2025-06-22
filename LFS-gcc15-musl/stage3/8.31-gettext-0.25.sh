#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('acl attr gcc-libs ncurses bash')
#https://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.xz

export PACKAGE=gettext-0.25
tar xf $SOURCES/gettext-0.25.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --disable-static \
            --docdir=/usr/share/doc/gettext-0.25

make

make check
# ============================================================================
# Testsuite summary for gettext-tools 0.25
# ============================================================================
# # TOTAL: 642
# # PASS:  602
# # SKIP:  35
# # XFAIL: 0
# # FAIL:  5
# # XPASS: 0
# # ERROR: 0

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

popd

rm -rf $PACKAGE
