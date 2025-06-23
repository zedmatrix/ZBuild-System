#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('acl glibc|musl attr')

#https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz

export PACKAGE=tar-1.35
bsdtar -xf $SOURCES/tar-1.35.tar.xz && pushd $PACKAGE

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

make

make check
## ------------- ##
## Test results. ##
## ------------- ##
# 224 tests were run,
# 1 failed unexpectedly.
# 20 tests were skipped.
# 233: capabilities: binary store/restore              FAILED (capabs_raw01.at:28)

make install

## Optional Documentation Install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

popd

rm -rf $PACKAGE
