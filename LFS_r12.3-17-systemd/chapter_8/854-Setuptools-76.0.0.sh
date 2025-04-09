#!/bin/bash
#       Install Zbuild v3.4 - LFS - PIP Build System
#
#	8.54. Setuptools-76.0.0
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
pkgname=setuptools
pkgver=76.0.0
pkgurl="https://pypi.org/packages/source/s/setuptools/setuptools-76.0.0.tar.gz"
zdelete="true"
#
#   Build Functions
#
Src_configure() {
	echo " Python PIP3 Install "
}
Src_compile() {
	pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD || return 77
}
Src_install() {
    pip3 install --no-index --find-links dist $pkgname || return 55
}
export pkgname pkgver pkgurl zdelete
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
    unset pkgname pkgver pkgurl zdelete
fi
