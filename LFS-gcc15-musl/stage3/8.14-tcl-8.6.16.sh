#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# https://downloads.sourceforge.net/tcl/tcl8.6.16-src.tar.gz
# https://downloads.sourceforge.net/tcl/tcl8.6.16-html.tar.gz
DEPENDS=(zlib)

export PACKAGE=tcl-8.6.16
mkdir -v $PACKAGE &&
tar xf $SOURCES/tcl8.6.16-src.tar.gz -C $PACKAGE \
 --strip-components=1 && pushd $PACKAGE

SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr --mandir=/usr/share/man --disable-rpath

make

sed -e "s|$SRCDIR/unix|/usr/lib|" -e "s|$SRCDIR|/usr/include|" \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|"             \
    -i pkgs/tdbc1.1.10/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|"            \
    -i pkgs/itcl4.3.2/itclConfig.sh

unset SRCDIR

make test
## Tests ended at Fri Jun 20 02:33:02 +0000 2025
## all.tcl:        Total   47053   Passed  43642   Skipped 3409    Failed  2
## Sourced 152 Test Files.
## Files with failing tests: unixInit.test
## Test files exiting with errors:   thread.test
#make test TESTFLAGS="-skip 'thread-4.5 thread-5* http* unixInit-3*'"

make install
make install-private-headers
chmod -v u+w /usr/lib/libtcl8.6.so

ln -sfv tclsh8.6 /usr/bin/tclsh
mv -v /usr/share/man/man3/{Thread,Tcl_Thread}.3

# Optional Doumentation
#cd ..
#tar -xf $SOURCES/tcl8.6.16-html.tar.gz --strip-components=1
#mkdir -v -p /usr/share/doc/tcl-8.6.16
#cp -v -r  ./html/* /usr/share/doc/tcl-8.6.16

popd

rm -rf $PACKAGE
