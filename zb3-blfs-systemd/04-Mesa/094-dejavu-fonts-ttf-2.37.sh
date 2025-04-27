#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	dejavu-fonts-ttf-2.37
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
pkgname=dejavu-fonts-ttf
pkgver=2.37
pkgdir=${pkgname}-${pkgver}
pkgurl="http://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2"
pkgmd5='d0efec10b9f110a32e9b8f796e21782c'
pkgpatch=""
zdelete="true"
#
#   Build Functions
#
Src_configure() {
	return 0
}
Src_compile() {
	return 0
}
Src_install() {
	install -v -d -m755 /usr/share/fonts/dejavu
	install -v -m644 ttf/*.ttf /usr/share/fonts/dejavu
	fc-cache -v /usr/share/fonts/dejavu
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
fi
