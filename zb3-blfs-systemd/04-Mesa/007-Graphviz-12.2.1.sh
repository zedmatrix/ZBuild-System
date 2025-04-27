#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Graphviz-12.2.1
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
pkgname=Graphviz
pkgver=12.2.1
pkgurl="https://gitlab.com/graphviz/graphviz/-/archive/12.2.1/graphviz-12.2.1.tar.bz2"
pkgmd5='4a4dbe47b00b07cd6ba01c75f7d02e6a'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --with-webp --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_prepare() {
	sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac && echo " Patched "
	./autogen.sh
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
	sed -i "s/0/$(date +%Y%m%d)/" builddate.h
    make || return 77
}
Src_install() {
    make install || return 55
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
