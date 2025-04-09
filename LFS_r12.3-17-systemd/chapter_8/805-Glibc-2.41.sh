#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	8.5. Glibc-2.41
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
pkgname=glibc
pkgver=2.41
pkgurl="https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz"
pkgpatch="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.41-fhs-1.patch"
zdelete="true"
#   Configure
packagedir="${pkgname}-${pkgver}"
zconfig="--prefix=/usr --disable-werror --enable-kernel=5.4 --enable-stack-protector=strong"
zconfig="${zconfig} --disable-nscd libc_cv_slibdir=/usr/lib"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
	echo "rootsbindir=/usr/sbin" > configparms
    ../configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"
	touch /etc/ld.so.conf
	sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile && echo " Patched "
}
Src_install() {
    make install || return 55
    sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd && echo " Patched "
    make localedata/install-locales
}
export pkgname pkgver pkgurl zdelete zconfig
export -f Src_prepare
export -f Src_configure
export -f Src_compile
export -f Src_check
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
	unset -f Src_check
    unset -f Src_install
    unset pkgname pkgver pkgurl zdelete zconfig
fi
