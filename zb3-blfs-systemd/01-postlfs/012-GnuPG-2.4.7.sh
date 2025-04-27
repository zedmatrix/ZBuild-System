#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	GnuPG-2.4.7
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
pkgname=gnupg
pkgver=2.4.7
pkgurl="https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.7.tar.bz2"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --localstatedir=/var --sysconfdir=/etc --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    ../configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
	makeinfo --html --no-split -I doc -o doc/gnupg_nochunks.html ../doc/gnupg.texi
	makeinfo --plaintext -I doc -o doc/gnupg.txt ../doc/gnupg.texi
	make -C doc html
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
}
Src_post() {
	install -v -m755 -d /usr/share/doc/$pkgdir/html
	install -v -m644 doc/gnupg_nochunks.html /usr/share/doc/$pkgdir/html/gnupg.html
	install -v -m644 ../doc/*.texi doc/gnupg.txt /usr/share/doc/$pkgdir
	install -v -m644 doc/gnupg.html/* /usr/share/doc/$pkgdir/html
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
export -f Src_prepare
export -f Src_configure
export -f Src_compile
export -f Src_check
export -f Src_install
export -f Src_post

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
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
