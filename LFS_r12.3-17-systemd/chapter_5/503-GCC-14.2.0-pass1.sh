#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	5.3. GCC-14.2.0 - Pass 1
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
zconfig="--target=$LFS_TGT --prefix=$LFS/tools --with-glibc-version=2.41 --with-sysroot=$LFS --with-newlib"
zconfig="${zconfig} --enable-default-pie --enable-default-ssp --disable-nls --disable-shared --disable-multilib"
zconfig="${zconfig} --disable-threads --disable-libatomic --disable-libgomp --disable-libquadmath --disable-libssp"
zconfig="${zconfig} --disable-libvtv --disable-libstdcxx --without-headers --enable-languages=c,c++"
#
#   Build Functions
#
Src_prepare() {
	tar -xf ${ZBUILD_sources}/mpfr-4.2.1.tar.xz || return 99
	mv -v mpfr-4.2.1 mpfr
	tar -xf ${ZBUILD_sources}/gmp-6.3.0.tar.xz || return 99
	mv -v gmp-6.3.0 gmp
	tar -xf ${ZBUILD_sources}/mpc-1.3.1.tar.gz || return 99
	mv -v mpc-1.3.1 mpc

	case $(uname -m) in
	  x86_64)
	    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	 ;;
	esac
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
    cd ..
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h && echo "created limits.h"
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
