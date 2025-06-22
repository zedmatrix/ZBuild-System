#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('expat perl')

#https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz

export PACKAGE=XML-Parser-2.47
tar xf $SOURCES/XML-Parser-2.47.tar.gz && pushd $PACKAGE

perl Makefile.PL

make

make test
## All tests successful.
## Files=15, Tests=140,  1 wallclock secs
## Result: PASS

make install

popd

rm -rf $PACKAGE
