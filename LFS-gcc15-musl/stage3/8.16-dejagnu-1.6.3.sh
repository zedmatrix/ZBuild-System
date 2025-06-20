#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=(expect bash tcl)

#https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz

export PACKAGE=dejagnu-1.6.3
tar xf $SOURCES/dejagnu-1.6.3.tar.gz && pushd $PACKAGE

mkdir -v build && cd build

../configure --prefix=/usr

makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi

make check
## === runtest Summary ===
## of expected passes            300
## DejaGnu version 1.6.3
## Expect version  5.45.4
## Tcl version     8.6

make install
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

popd

rm -rf $PACKAGE
