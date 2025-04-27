#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	alsa-lib-1.2.13
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
pkgname=alsa-lib
pkgver=1.2.13
pkgurl="https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.13.tar.bz2"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
    ./configure || return 88
}
Src_compile() {
    make || return 77
	make doc
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
	install -v -d -m755 /usr/share/doc/${pkgdir}/html/search
	install -v -m644 doc/doxygen/html/*.* /usr/share/doc/${pkgdir}/html
	install -v -m644 doc/doxygen/html/search/* /usr/share/doc/${pkgdir}/html/search
	tar -C /usr/share/alsa --strip-components=1 -xf /sources/alsa-ucm-conf-1.2.13.tar.bz2
}
export pkgname pkgver pkgurl pkgdir zdelete
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
    unset pkgname pkgver pkgurl pkgdir zdelete
fi
