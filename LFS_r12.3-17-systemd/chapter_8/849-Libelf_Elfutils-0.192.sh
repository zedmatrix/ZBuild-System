#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.49. Libelf from Elfutils-0.192
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
pkgname=elfutils
pkgver=0.192
pkgurl="https://sourceware.org/ftp/elfutils/0.192/elfutils-0.192.tar.bz2"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --disable-debuginfod --enable-libdebuginfod=dummy"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make -C libelf install || return 55
    install -vm644 config/libelf.pc /usr/lib/pkgconfig
	rm /usr/lib/libelf.a
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset -f Src_configure
    unset -f Src_compile
	unset -f Src_check
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
