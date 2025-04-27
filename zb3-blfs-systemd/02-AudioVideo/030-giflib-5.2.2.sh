#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	giflib-5.2.2
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
pkgname=giflib
pkgver=5.2.2
pkgurl="https://sourceforge.net/projects/giflib/files/giflib-5.2.2.tar.gz"
pkgmd5='913dd251492134e235ee3c9a91987a4d'
pkgpatch="giflib-5.2.2-upstream_fixes-1.patch"
zdelete="true"
#
#   Build Functions
#
Src_configure() {
	echo " Remove an Un-Necessary Dependency on ImageMagick "
	cp -v pic/gifgrid.gif doc/giflib-logo.gif
}
Src_compile() {
    make || return 77
}
Src_install() {
    make PREFIX=/usr install || return 55
	rm -fv /usr/lib/libgif.a
	find doc \( -name Makefile\* -o -name \*.1 -o -name \*.xml \) -exec rm -v {} \;
	install -v -dm755 /usr/share/doc/$pkgdir
	cp -v -R doc/* /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
fi
