#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libevdev 1.13.4
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
pkgname=libevdev
pkgver=1.13.4
pkgdir=${pkgname}-${pkgver}
pkgurl="https://www.freedesktop.org/software/libevdev/libevdev-1.13.4.tar.xz"
pkgmd5='2e8a4665e332699ccba7ee54a0dd189a'
pkgpatch=""
zdelete="true"
#	Meson
zconfig="--prefix=/usr --buildtype=release -D tests=disabled"
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
Src_install() {
    ninja install || return 55
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
