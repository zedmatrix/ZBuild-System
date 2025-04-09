#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	7.12. Util-linux-2.40.4
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
pkgname=util-linux
pkgver=2.40.4
pkgurl="https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.4.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--libdir=/usr/lib --runstatedir=/run --disable-chfn-chsh --disable-login --disable-nologin"
zconfig="${zconfig} --disable-su --disable-setpriv --disable-runuser --disable-pylibmount"
zconfig="${zconfig} --disable-static --disable-liblastlog2 --without-python"
zconfig="${zconfig} ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_configure() {
	mkdir -pv /var/lib/hwclock
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
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
