#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libaom-3.12.0
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
pkgname=libaom
pkgver=3.12.0
pkgurl="https://storage.googleapis.com/aom-releases/libaom-3.12.0.tar.gz"
pkgmd5='aabd9c71c7d52c837ec276156d5a953f'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="-D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release"
zconfig="${zconfig} -D BUILD_SHARED_LIBS=1 -D ENABLE_DOCS=no -G Ninja"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v aom-build
    cd aom-build
}
Src_configure() {
	cmake .. ${zconfig} || return 88
}
Src_compile() {
    ninja  || return 77
}
Src_check() {
    ninja testdata 2>&1 | tee "${ZBUILD_log}/${pkgdir}-test.log"
}
Src_install() {
    ninja install || return 55
	rm -v /usr/lib/libaom.a
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
