#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz
DEPENDS=(tcl)

export PACKAGE=expect-5.45.4
mkdir -v $PACKAGE &&
tar xf $SOURCES/expect5.45.4.tar.gz -C $PACKAGE \
 --strip-components=1 && pushd $PACKAGE

python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

patch -Np1 -i $SOURCES/expect-5.45.4-gcc15-1.patch

./configure --prefix=/usr --with-tcl=/usr/lib --enable-shared \
 --disable-rpath --mandir=/usr/share/man --with-tclinclude=/usr/include

make

make test
## all.tcl:        Total   29      Passed  29      Skipped 0       Failed  0
## Sourced 0 Test Files.

make install

ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

popd

rm -rf $PACKAGE
