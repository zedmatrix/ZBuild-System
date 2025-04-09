#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	8.76. Systemd-257.3
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
zconfig="--prefix=/usr --buildtype=release -D default-dnssec=no -D firstboot=false -D install-tests=false"
zconfig="${zconfig} -D ldconfig=false -D sysusers=false -D rpmmacrosdir=no -D homed=disabled -D userdb=false -D man=disabled"
zconfig="${zconfig} -D mode=release -D pamconfdir=no -D dev-kvm-mode=0660 -D nobody-group=nogroup"
zconfig="${zconfig} -D sysupdate=disabled -D ukify=disabled -Ddocdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_prepare() {
	sed -e 's/GROUP="render"/GROUP="video"/' -e 's/GROUP="sgx", //' -i rules.d/50-udev-default.rules.in
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
	echo 'NAME="Linux From Scratch"' > /etc/os-release
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
