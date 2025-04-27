#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	NSS-3.109
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
pkgname=nss
pkgver=3.109
pkgurl="https://archive.mozilla.org/pub/security/nss/releases/NSS_3_109_RTM/src/nss-3.109.tar.gz"
pkgpatch="nss-standalone-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="BUILD_OPT=1 NSPR_INCLUDE_DIR=/usr/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz NSS_ENABLE_WERROR=0"
zconfig="${zconfig} USE_64=1 NSS_USE_SYSTEM_SQLITE=1"
#
#   Build Functions
#
Src_configure() {
    return 0
}
Src_compile() {
	cd nss
    make ${zconfig} || return 77
}
Src_check() {
	cd tests
    HOST=localhost DOMSUF=localdomain ./all.sh | tee "${ZBUILD_log}/${pkgdir}-check.log"
	cd ../
}
Src_install() {
	cd ../dist
	install -v -m755 Linux*/lib/*.so /usr/lib
	install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib
	install -v -m755 -d /usr/include/nss
	cp -v -RL {public,private}/nss/* /usr/include/nss
	install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin
	install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig
	ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
}
export pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
fi
