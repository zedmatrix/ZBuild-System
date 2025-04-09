#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	8.61. Gawk-5.3.1
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
pkgname=gawk
pkgver=5.3.1
pkgurl="https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
	sed -i 's/extras//' Makefile.in && echo " Patched "
    ./configure --prefix=/usr || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
	chown -R tester .
	su tester -c "PATH=$PATH make check" 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
	rm -f /usr/bin/gawk-5.3.1
    make install || return 55
    ln -sv gawk.1 /usr/share/man/man1/awk.1
    install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/$pkgdir
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
