#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	8.7. Bzip2-1.0.8
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
pkgname=bzip2
pkgver=1.0.8
pkgurl="https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
pkgpatch="bzip2-1.0.8-install_docs-1.patch"
zdelete="true"
#
#   Build Functions
#
Src_configure() {
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile && echo " Patched "
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile && echo " Patched "
}
Src_compile() {
	make -f Makefile-libbz2_so
	make clean
    make || return 77
}
Src_install() {
    make PREFIX=/usr install || return 55
    cp -av libbz2.so.* /usr/lib
	ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
	cp -v bzip2-shared /usr/bin/bzip2
	for i in /usr/bin/{bzcat,bunzip2}; do
	  ln -sfv bzip2 $i
	done
	rm -fv /usr/lib/libbz2.a
}
export pkgname pkgver pkgurl pkgpatch zdelete
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
    unset pkgname pkgver pkgurl pkgpatch zdelete
fi
