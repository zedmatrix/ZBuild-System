#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Perl - 5.40.2

tar xf $SOURCES/perl-5.40.2.tar.xz && pushd perl-5.40.2

sh Configure -des -D prefix=/usr -D vendorprefix=/usr -D useshrplib \
   -D privlib=/usr/lib/perl5/5.40/core_perl -D archlib=/usr/lib/perl5/5.40/core_perl \
   -D sitelib=/usr/lib/perl5/5.40/site_perl -D sitearch=/usr/lib/perl5/5.40/site_perl \
   -D vendorlib=/usr/lib/perl5/5.40/vendor_perl -D vendorarch=/usr/lib/perl5/5.40/vendor_perl

make

make install

popd

rm -rf perl-5.40.2
