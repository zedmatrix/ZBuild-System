#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Sudo-1.9.16p2
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
pkgname=sudo
pkgver=1.9.16p2
pkgurl="https://www.sudo.ws/dist/sudo-1.9.16p2.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --libexecdir=/usr/lib --with-secure-path --with-env-editor"
zconfig="${zconfig} --docdir=/usr/share/doc/$pkgdir --with-passprompt="
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig}"[sudo] password for %p: " || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    env LC_ALL=C make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
}
Src_post() {
	grep failed ${ZBUILD_log}/${pkgdir}-check.log || echo " All Passed "
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
export -f Src_configure
export -f Src_compile
export -f Src_check
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
	unset -f Src_check
    unset -f Src_install
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
