#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Libdrm-2.4.124
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
pkgname=Libdrm
pkgver=2.4.124
pkgurl="https://dri.freedesktop.org/libdrm/libdrm-2.4.124.tar.xz"
pkgmd5='78f7f7ee6aff711696d4b34465b40728'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --buildtype=release -D udev=true -D valgrind=disabled"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    meson setup .. ${zconfig} || return 88
}
Src_compile() {
    ninja  || return 77
}
Src_check() {
    ninja test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-test.log"
}
Src_install() {
    ninja install || return 55
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
export -f Src_prepare
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
    unset -f Src_prepare
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_check
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
