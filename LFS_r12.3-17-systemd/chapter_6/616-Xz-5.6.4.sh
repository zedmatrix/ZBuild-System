#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	6.16. Xz-5.6.4
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
pkgname=xz
pkgver=5.6.4
pkgurl="https://github.com//tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --host=$LFS_TGT --disable-static --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_configure() {
    ./configure --build=$(build-aux/config.guess) ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$LFS install || return 55
	rm -v $LFS/usr/lib/liblzma.la
}
export pkgname pkgver pkgurl zdelete zconfig
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
    unset pkgname pkgver pkgurl zdelete zconfig
fi
