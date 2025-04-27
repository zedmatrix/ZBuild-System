#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	CDParanoia-III-10.2
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
pkgname=cdparanoia-III
pkgver=10.2
pkgurl="https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
pkgmd5='b304bbe8ab63373924a744eac9ebc652'
pkgpatch="cdparanoia-III-10.2-gcc_fixes-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --mandir=/usr/share/man"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make -j1 || return 77
}
Src_install() {
    make install || return 55
	chmod -v 755 /usr/lib/libcdda_*.so.0.10.2
	rm -fv /usr/lib/libcdda_*.a
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
fi
