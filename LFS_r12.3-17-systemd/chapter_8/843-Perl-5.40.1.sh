#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.43. Perl-5.40.1
#
#    unset functions
unset -f Src_prepare
unset -f Src_configure
unset -f Src_compile
unset -f Src_check
unset -f Src_install
#
# Global Settings
#
ZBUILD_root=/zbuild
ZBUILD_script=${ZBUILD_root}/zbuild4.sh
ZBUILD_log=${ZBUILD_root}/Zbuild_log
[ ! -d ${ZBUILD_root} ] && { echo "Error: ${ZBUILD_root} directory Missing. Exiting."; exit 2; }
[ ! -d ${ZBUILD_log} ] && mkdir -v $ZBUILD_log
[ ! -f ${ZBUILD_script} ] && { echo "ERROR: Missing ${ZBUILD_script}. Exiting."; exit 3; }

# pkgurl = archive
pkgname=perl
pkgver=5.40.1
pkgurl="https://www.cpan.org/src/5.0/perl-5.40.1.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="-des -D prefix=/usr -D vendorprefix=/usr -D useshrplib -D usethreads"
zconfig="${zconfig} -D privlib=/usr/lib/perl5/5.40/core_perl -D archlib=/usr/lib/perl5/5.40/core_perl"
zconfig="${zconfig} -D sitelib=/usr/lib/perl5/5.40/site_perl -D sitearch=/usr/lib/perl5/5.40/site_perl"
zconfig="${zconfig} -D vendorlib=/usr/lib/perl5/5.40/vendor_perl -D vendorarch=/usr/lib/perl5/5.40/vendor_perl"
zconfig="${zconfig} -D man1dir=/usr/share/man/man1 -D man3dir=/usr/share/man/man3 -D pager="
#
#   Build Functions
#
Src_configure() {
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0
    sh Configure ${zconfig}"/usr/bin/less -isR" || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    TEST_JOBS=$(nproc) make test_harness 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
    unset BUILD_ZLIB BUILD_BZIP2
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
export -f Src_configure
export -f Src_compile
export -f Src_check
export -f Src_install

if [ -f ${ZBUILD_script} ]; then
    ${ZBUILD_script}
    exitcode=$?
else
    printf "\n\t Error: Missing ZBUILD_script. \n"
    exitcode=2
fi

if [[ $exitcode -ne 0 ]]; then
    printf "\n\t Error Code: ${exitcode} \n"
else
    printf "\t Success \n"
    unset -f Src_configure
    unset -f Src_compile
	unset -f Src_check
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
