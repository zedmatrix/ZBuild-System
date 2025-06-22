#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gdbm glibc|musl libxcrypt')

#https://www.cpan.org/src/5.0/perl-5.40.2.tar.xz
#https://www.linuxfromscratch.org/patches/lfs/development/perl-5.40.2-upstream_fix-1.patch

export PACKAGE=perl-5.40.2
tar xf $SOURCES/perl-5.40.2.tar.xz && pushd $PACKAGE

patch -Np1 -i $SOURCES/perl-5.40.2-upstream_fix-1.patch

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -D prefix=/usr -D vendorprefix=/usr -D useshrplib -D usethreads \
  -D privlib=/usr/lib/perl5/5.40/core_perl -D archlib=/usr/lib/perl5/5.40/core_perl \
  -D sitelib=/usr/lib/perl5/5.40/site_perl -D sitearch=/usr/lib/perl5/5.40/site_perl \
  -D vendorlib=/usr/lib/perl5/5.40/vendor_perl -D vendorarch=/usr/lib/perl5/5.40/vendor_perl \
  -D man1dir=/usr/share/man/man1 -D man3dir=/usr/share/man/man3 -D pager="/usr/bin/less -isR" \
  -A ccflags='-D_GNU_SOURCE=1'

make

TEST_JOBS=$(nproc) make test_harness 2>&1 | tee perl-test-harness-log
## All tests successful.
## Files=2895, Tests=1198047, 269 wallclock secs (77.77 usr  8.51 sys + 546.74 cusr 68.06 csys = 701.08 CPU)
## Result: PASS
## Finished test run at Sat Jun 21 16:43:44 2025.

make install
unset BUILD_ZLIB BUILD_BZIP2

popd

rm -rf $PACKAGE
