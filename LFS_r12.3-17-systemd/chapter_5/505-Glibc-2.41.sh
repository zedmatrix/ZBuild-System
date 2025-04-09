#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	5.5. Glibc-2.41
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
pkgname=glibc
pkgver=2.41
pkgurl="https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz"
pkgpatch="glibc-2.41-fhs-1.patch"
zdelete="true"
#   Configure
zconfig="--prefix=/usr --host=$LFS_TGT --enable-kernel=5.4 --disable-nscd libc_cv_slibdir=/usr/lib"
#
#   Build Functions
#
Src_prepare() {
	case $(uname -m) in
    	i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
	    ;;
	    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
    	        ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
	    ;;
	esac
    mkdir -v build
    cd build
}
Src_configure() {
	echo "rootsbindir=/usr/sbin" > configparms
    ../configure ${zconfig} --build=$(../scripts/config.guess) || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$LFS install || return 55
}
export pkgname pkgver pkgurl pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgpatch zdelete zconfig
fi
