#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	6.18. GCC-14.2.0 - Pass 2
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
zconfig="--prefix=/usr --host=$LFS_TGT --target=$LFS_TGT LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc"
zconfig="${zconfig} --with-build-sysroot=$LFS --enable-default-pie --enable-default-ssp --disable-nls"
zconfig="${zconfig} --disable-multilib --disable-libatomic --disable-libgomp --disable-libquadmath"
zconfig="${zconfig} --disable-libsanitizer --disable-libssp --disable-libvtv --enable-languages=c,c++"

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
	    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64 && echo " Patched "
	  ;;
	esac
	sed '/thread_header =/s/@.*@/gthr-posix.h/' \
	-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in && echo " Patched "
    mkdir -v build
    cd build
}
Src_configure() {
    ../configure --build=$(../config.guess) ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$LFS install || return 55
    ln -sv gcc $LFS/usr/bin/cc
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
