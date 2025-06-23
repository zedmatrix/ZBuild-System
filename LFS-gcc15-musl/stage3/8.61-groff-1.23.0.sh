#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gcc-libs perl')

#https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz

export PACKAGE=groff-1.23.0
tar xf $SOURCES/groff-1.23.0.tar.gz && pushd $PACKAGE

## patch out a conflict with musl's own header definition
sed -i '/^extern char \*getenv *()/d' src/libs/libgroff/getopt.c
sed -i '/#  include <string.h>/a #include <stdlib.h>' src/libs/libgroff/getopt.c
sed -i 's/^extern int getopt *(.*);$/extern int getopt (int, char * const *, const char *);/' src/libs/libgroff/getopt.c

PAGE=letter ./configure --prefix=/usr

make

make check
# ============================================================================
# Testsuite summary for GNU roff 1.23.0
## TOTAL: 164
## PASS:  151
## SKIP:  11
## XFAIL: 2
## FAIL:  0
## XPASS: 0
## ERROR: 0

make install

popd
rm -rf $PACKAGE
