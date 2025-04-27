#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	lm-sensors-3-6-0
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
pkgname=lm-sensors
pkgver=3-6-0
pkgdir=${pkgname}-${pkgver}
pkgurl="https://github.com/lm-sensors/lm-sensors/archive/V3-6-0/lm-sensors-3-6-0.tar.gz"
pkgmd5='f60e47b5eb50bbeed48a9f43bb08dd5e'
pkgpatch=""
zdelete="true"
zconfig="PREFIX=/usr BUILD_STATIC_LIB=0 MANDIR=/usr/share/man"
#
#   Build Functions
#
Src_configure() {
	return 0
}
Src_compile() {
    make $zconfig EXLDFLAGS= || return 77
}
Src_install() {
    make $zconfig install || return 55
	install -v -m755 -d /usr/share/doc/$pkgdir
	cp -rv README INSTALL doc/* /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
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
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
