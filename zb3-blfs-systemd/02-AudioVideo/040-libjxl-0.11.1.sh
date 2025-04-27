#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libjxl-0.11.1
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
pkgname=libjxl
pkgver=0.11.1
pkgurl="https://github.com/libjxl/libjxl/archive/v0.11.1/libjxl-0.11.1.tar.gz"
pkgmd5='8f26fc954c2d9cb377544a5f029182ef'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="-D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release -D JPEGXL_ENABLE_PLUGINS=ON"
zconfig="${zconfig} -D BUILD_TESTING=OFF -D BUILD_SHARED_LIBS=ON -D JPEGXL_ENABLE_SKCMS=OFF -G Ninja"
zconfig="${zconfig} -D JPEGXL_ENABLE_SJPEG=OFF -D JPEGXL_INSTALL_JARDIR=/usr/share/java"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
	cmake .. ${zconfig} || return 88
}
Src_compile() {
    ninja  || return 77
}
Src_install() {
    ninja install || return 55
	gdk-pixbuf-query-loaders --update-cache
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
