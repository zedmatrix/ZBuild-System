#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Systemd-257.3 - pass 2 - Linux-PAM-1.7.0 - re-install
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
pkgname=systemd
pkgver=257.3
pkgurl="https://github.com/systemd/systemd/archive/v257.3/systemd-257.3.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --buildtype=release -Ddocdir=/usr/share/doc/$pkgdir -Dukify=disabled -Dmode=release"
zconfig="${zconfig} -Ddefault-dnssec=no -Dfirstboot=false -Dinstall-tests=false -Dldconfig=false"
zconfig="${zconfig} -Dman=false -Dsysusers=false -Drpmmacrosdir=no -Dhomed=disabled -Duserdb=false"
zconfig="${zconfig} -Dpam=enabled -Dpamconfdir=/etc/pam.d -Ddev-kvm-mode=0660 -Dnobody-group=nogroup -Dsysupdate=disabled"
#
#   Build Functions
#
Src_prepare() {
	sed -i -e 's/GROUP="render"/GROUP="video"/' -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
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
