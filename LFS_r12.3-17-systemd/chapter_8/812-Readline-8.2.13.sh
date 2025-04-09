#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.12. Readline-8.2.13
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
pkgname=readline
pkgver=8.2.13
pkgurl="https://ftp.gnu.org/gnu/readline/readline-8.2.13.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --disable-static --with-curses --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_prepare() {
	sed -i '/MV.*old/d' Makefile.in && echo " Patched "
	sed -i '/{OLDSUFF}/c:' support/shlib-install && echo " Patched "
	sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf && echo " Patched "
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make SHLIB_LIBS="-lncursesw" || return 77
}
Src_install() {
    make install || return 55
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
