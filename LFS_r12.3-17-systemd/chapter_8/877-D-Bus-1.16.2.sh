#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	8.77. D-Bus-1.16.2
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
pkgname=dbus
pkgver=1.16.2
pkgurl="https://dbus.freedesktop.org/releases/dbus/dbus-1.16.2.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --buildtype=release --wrap-mode=nofallback"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    meson setup .. ${zconfig} || return 88
}
Src_compile() {
    ninja || return 77
}
Src_check() {
    ninja test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    ninja install || return 55
    ln -sfv /etc/machine-id /var/lib/dbus
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
