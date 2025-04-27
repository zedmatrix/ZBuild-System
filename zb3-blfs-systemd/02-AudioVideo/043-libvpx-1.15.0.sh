#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libvpx-1.15.0
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
pkgname=libvpx
pkgver=1.15.0
pkgurl="https://github.com/webmproject/libvpx/archive/v1.15.0/libvpx-1.15.0.tar.gz"
pkgmd5='6d2b7b8e1c06f4b10ae63ca22491f8a4'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --disable-static --enable-shared"
#
#   Build Functions
#
Src_prepare() {
	sed -i 's/cp -p/cp/' build/make/Makefile && echo " Patched "
    mkdir -v libvpx-build
    cd libvpx-build
}
Src_configure() {
    ../configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    LD_LIBRARY_PATH=. make test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
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
