#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.20. Binutils-2.44
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
pkgname=binutils
pkgver=2.44
pkgurl="https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --sysconfdir=/etc --enable-ld=default --enable-plugins --enable-shared --disable-werror"
zconfig="${zconfig} --enable-64-bit-bfd --enable-new-dtags --with-system-zlib --enable-default-hash-style=gnu"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    ../configure ${zconfig} || return 88
}
Src_compile() {
    make tooldir=/usr || return 77
}
Src_check() {
    make -k check 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"
}
Src_install() {
    make tooldir=/usr install || return 55
    rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a /usr/share/doc/gprofng/
    grep '^FAIL:' ${ZBUILD_log}/${packagedir}-check.log
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
