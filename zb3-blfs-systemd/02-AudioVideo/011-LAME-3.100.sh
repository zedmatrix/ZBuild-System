#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	LAME-3.100
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
pkgname=lame
pkgver=3.100
pkgurl="https://downloads.sourceforge.net/lame/lame-3.100.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --enable-mp3rtp --enable-nasm --disable-static"
#
#   Build Functions
#
Src_configure() {
	sed -i -e 's/^\(\s*hardcode_libdir_flag_spec\s*=\).*/\1/' configure && echo " Patched "
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    LD_LIBRARY_PATH=libmp3lame/.libs make test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make pkghtmldir=/usr/share/doc/$pkgdir install || return 55
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
