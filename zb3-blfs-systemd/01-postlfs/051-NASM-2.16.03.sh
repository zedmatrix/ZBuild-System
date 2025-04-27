#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	NASM-2.16.03
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
pkgname=nasm
pkgver=2.16.03
pkgurl="https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}

#
#   Build Functions
#
Src_configure() {
	tar -xf /sources/nasm-2.16.03-xdoc.tar.xz --strip-components=1 || return 99
    ./configure --prefix=/usr || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
	install -m755 -d /usr/share/doc/$pkgdir/html
	cp -v doc/html/*.html /usr/share/doc/$pkgdir/html
	cp -v doc/*.{txt,ps,pdf} /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete
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
    unset pkgname pkgver pkgurl pkgdir zdelete
fi
