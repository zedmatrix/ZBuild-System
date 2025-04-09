#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	5.6. Libstdc++ from GCC-14.2.0
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
pkgname=gcc
pkgver=14.2.0
pkgurl="https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
zconfig="--host=$LFS_TGT --prefix=/usr --disable-multilib --disable-nls --disable-libstdcxx-pch"
zconfig="${zconfig} --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    ../libstdc++-v3/configure --build=$(../config.guess) ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$LFS install || return 55
    rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
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
    unset pkgname pkgver pkgurl zdelete zconfig
fi
