#!/bin/bash
#       Install Zbuild v3.4 - BLFS - Xorg Base System
#
#	xcb-util-wm-0.4.2
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
pkgname=xcb-util-wm
pkgver=0.4.2
pkgurl="https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.xz"
pkgmd5='581b3a092e3c0c1b4de6416d90b969c3'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
#   Xorg Configure
zconfig="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
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
