#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	5.2. Binutils-2.44 - Pass 1
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
ZBUILD_root=${LFS}/zbuild
ZBUILD_script=${ZBUILD_root}/zbuild_lfs.sh
ZBUILD_log=${ZBUILD_root}/Zbuild_log
[ ! -d ${ZBUILD_root} ] && { echo "Error: ${ZBUILD_root} directory Missing. Exiting."; exit 2; }
[ ! -d ${ZBUILD_log} ] && mkdir -v $ZBUILD_log
[ ! -f ${ZBUILD_script} ] && { echo "ERROR: Missing ${ZBUILD_script}. Exiting."; exit 3; }

pkgname=binutils
pkgver=2.44
pkgurl="https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
zconfig="--prefix=$LFS/tools --with-sysroot=$LFS --target=$LFS_TGT --disable-nls --enable-gprofng=no"
zconfig="${zconfig} --disable-werror --enable-new-dtags --enable-default-hash-style=gnu"
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
    make || return 77
}
Src_install() {
    make install || return 55
}
export pkgname pkgver pkgurl zdelete zconfig
export -f Src_prepare
export -f Src_configure
export -f Src_compile
export -f Src_install

if [ -f ${ZBUILD_script} ]; then
    ${ZBUILD_script}
    exitcode=$?
else
    printf " Error: Missing ZBUILD_script. \n"
    exitcode=2
fi

if [[ $exitcode -ne 0 ]]; then
    printf " Error Code: ${exitcode} \n"
else
    printf " \t Success \n "
    unset -f Src_prepare
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_install
    unset pkgname pkgver pkgurl zdelete zconfig
fi
