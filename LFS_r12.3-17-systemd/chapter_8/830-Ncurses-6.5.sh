#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.30. Ncurses-6.5
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
pkgname=ncurses
pkgver=6.5
pkgurl="https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --mandir=/usr/share/man --with-shared --without-debug --without-normal --with-cxx-shared"
zconfig="${zconfig} --enable-pc-files --with-pkg-config-libdir=/usr/lib/pkgconfig"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$PWD/dest install || return 55
    install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
	rm -v  dest/usr/lib/libncursesw.so.6.5
	sed -e 's/^#if.*XOPEN.*$/#if 1/' -i dest/usr/include/curses.h
	cp -av dest/* /
}
Src_post() {
	for lib in ncurses form panel menu ; do
	    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    	ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
	done
	ln -sfv libncursesw.so /usr/lib/libcurses.so
	cp -v -R doc -T /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
export -f Src_configure
export -f Src_compile
export -f Src_install
export -f Src_post

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
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
