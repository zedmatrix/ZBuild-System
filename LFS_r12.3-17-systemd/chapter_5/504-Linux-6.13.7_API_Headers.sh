#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
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
LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
ZBUILD_root=${LFS}/zbuild
ZBUILD_script=${ZBUILD_root}/zbuild_lfs.sh
ZBUILD_log=${ZBUILD_root}/Zbuild_log
[ ! -d ${ZBUILD_root} ] && { echo "Error: ${ZBUILD_root} directory Missing. Exiting."; exit 2; }
[ ! -d ${ZBUILD_log} ] && mkdir -v $ZBUILD_log
[ ! -f ${ZBUILD_script} ] && { echo "ERROR: Missing ${ZBUILD_script}. Exiting."; exit 3; }

# pkgurl = archive
pkgname=linux
pkgver=6.13.7
pkgurl="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.13.7.tar.xz"
pkgpatch=""
zdelete="true"
#
#   Build Functions
#
Src_configure() {
    make mrproper || return 88
}
Src_compile() {
    make headers || return 77
}
Src_install() {
    find usr/include -type f ! -name '*.h' -delete
	cp -rv usr/include $LFS/usr
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
