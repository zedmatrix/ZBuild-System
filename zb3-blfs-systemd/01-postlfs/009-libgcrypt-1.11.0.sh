#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libgcrypt-1.11.0
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
pkgname=libgcrypt
pkgver=1.11.0
pkgurl="https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2"
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
	make -C doc html
	makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi
	makeinfo --plaintext -o doc/gcrypt.txt doc/gcrypt.texi
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
}
Src_post() {
	install -v -dm755 /usr/share/doc/$pkgdir
	install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} /usr/share/doc/$pkgdir
	install -v -dm755 /usr/share/doc/$pkgdir/html
	install -v -m644 doc/gcrypt.html/* /usr/share/doc/$pkgdir/html
	install -v -m644 doc/gcrypt_nochunks.html /usr/share/doc/$pkgdir
	install -v -m644 doc/gcrypt.{txt,texi} /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete
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
    unset -f Src_configure
    unset -f Src_compile
	unset -f Src_check
    unset -f Src_install
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir zdelete
fi
