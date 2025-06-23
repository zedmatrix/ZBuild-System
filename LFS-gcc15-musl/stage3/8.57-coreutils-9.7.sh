#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('acl attr glibc gmp libcap openssl gperf python')

#https://ftp.gnu.org/gnu/coreutils/coreutils-9.7.tar.xz

## https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.7-upstream_fix-1.patch
## https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.7-i18n-1.patch

export PACKAGE=coreutils-9.7
tar xf $SOURCES/coreutils-9.7.tar.xz && pushd $PACKAGE

patch -Np1 -i $SOURCES/coreutils-9.7-upstream_fix-1.patch
patch -Np1 -i $SOURCES/coreutils-9.7-i18n-1.patch

autoreconf -fv

automake -af

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-no-install-program=kill,uptime

make

## Testsuite
make NON_ROOT_USERNAME=tester check-root
# ============================================================================
# Testsuite summary for GNU coreutils 9.7
#
## TOTAL: 36
## PASS:  21
## SKIP:  15
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0

## More Tests
groupadd -g 102 dummy -U tester
chown -R tester .
su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" < /dev/null
groupdel dummy
## ============================================================================
## Testsuite summary for GNU coreutils 9.7
## TOTAL: 527
## PASS:  442
## SKIP:  85
## XFAIL: 0
## FAIL:  0
## XPASS: 0
## ERROR: 0
## ============================================================================

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

## Clean Up
popd
rm -rf $PACKAGE
