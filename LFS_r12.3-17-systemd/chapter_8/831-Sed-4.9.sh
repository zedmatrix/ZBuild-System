#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.31. Sed-4.9
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
pkgname=sed
pkgver=4.9
pkgurl="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
    ./configure --prefix=/usr || return 88
}
Src_compile() {
    make || return 77
    make html
}
Src_check() {
	chown -R tester .
    su tester -c "PATH=$PATH make check" 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
    install -d -m755 /usr/share/doc/$pkgdir
    install -m644 doc/sed.html /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
