#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	p11-kit-0.25.5
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
pkgname=p11-kit
pkgver=0.25.5
pkgurl="https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --buildtype=release -D trust_paths=/etc/pki/anchors"
#
#   Build Functions
#
Src_prepare() {
	sed '20,$ d' -i trust/trust-extract-compat && echo " Patched "
	cat >> trust/trust-extract-compat << "EOF"
	# Copy existing anchor modifications to /etc/ssl/local
	/usr/libexec/make-ca/copy-trust-modifications

	# Update trust stores
	/usr/sbin/make-ca -r
EOF
}
Src_configure() {
    mkdir -v p11-build
    cd p11-build
    meson setup .. ${zconfig} || return 88
}
Src_compile() {
    ninja || return 77
}
Src_check() {
    LC_ALL=C ninja test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    ninja install || return 55
    ln -sfv /usr/libexec/p11-kit/trust-extract-compat /usr/bin/update-ca-certificates
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
