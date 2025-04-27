#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
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
pkgname=xterm
pkgver=398
pkgdir=${pkgname}-${pkgver}
pkgurl="https://invisible-mirror.net/archives/xterm/xterm-398.tgz"
pkgmd5='e33e4c47a6c6fb32f902ed7ec1e6db72'
pkgpatch=""
zdelete="true"
#   Configure
zconfig="--prefix=/usr --disable-static --sysconfdir=/etc --localstatedir=/var --with-app-defaults=/etc/X11/app-defaults"
#
#   Build Functions
#
Src_configure() {
	sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap && echo " Patched "
	printf '\tkbs=\\177,\n' >> terminfo && echo " Patched "
	TERMINFO=/usr/share/terminfo ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
	mkdir -pv /usr/share/applications
	cp -v *.desktop /usr/share/applications/
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
