#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Cbindgen-0.28.0
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
pkgname=cbindgen
pkgver=0.28.0
pkgurl="https://github.com/mozilla/cbindgen/archive/v0.28.0/cbindgen-0.28.0.tar.gz"
pkgmd5='0712d991fc8e65121924265d738db71d'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
	echo " Rust Build and Install "
}
Src_compile() {
	cargo build --release
}
Src_check() {
	cargo test --release | tee "${ZBUILD_log}/${pkgdir}-test.log"
}
Src_install() {
	install -vDm755 target/release/cbindgen /usr/bin/
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
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
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_check
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
fi
