#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	rust-bindgen-0.71.1
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
pkgname=rust-bindgen
pkgver=0.71.1
pkgurl="https://github.com/rust-lang/rust-bindgen/archive/v0.71.1/rust-bindgen-0.71.1.tar.gz"
pkgmd5='b59ecb112ad52cbba2297e650f507764'
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
    cargo test --release | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
	install -v -m755 target/release/bindgen /usr/bin
	bindgen --generate-shell-completions bash  > /usr/share/bash-completion/completions/bindgen
	bindgen --generate-shell-completions zsh > /usr/share/zsh/site-functions/_bindgen
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
