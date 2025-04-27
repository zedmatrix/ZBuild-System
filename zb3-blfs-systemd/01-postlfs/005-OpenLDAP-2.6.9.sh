#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	OpenLDAP-2.6.9
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
pkgname=openldap
pkgver=2.6.9
pkgurl="https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.9.tgz"
pkgpatch="openldap-2.6.9-consolidated-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --sysconfdir=/etc --disable-static --enable-dynamic --disable-debug --disable-slapd"
#
#   Build Functions
#
Src_prepare() {
	autoconf || return 99
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
	make depend
    make || return 77
}
Src_install() {
    make install || return 55
}
export pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
export -f Src_prepare
export -f Src_configure
export -f Src_compile
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
    unset -f Src_prepare
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
fi
