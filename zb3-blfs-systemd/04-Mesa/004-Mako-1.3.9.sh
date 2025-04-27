#!/bin/bash
#       Install Zbuild v3.4 - LFS - PIP Install
#
#	Mako-1.3.9
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
pkgname=Mako
pkgver=1.3.9
pkgurl="https://files.pythonhosted.org/packages/source/M/Mako/mako-1.3.9.tar.gz"
pkgmd5='28b1b70e01a1240c90e97fab2f17e349'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
	printf "\n\t PIP Build and Install \n"
	return 0
}
Src_compile() {
	pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
}
Src_install() {
	pip3 install --no-index --find-links dist --no-user $pkgname
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete
fi
