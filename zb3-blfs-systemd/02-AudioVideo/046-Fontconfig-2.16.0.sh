#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Fontconfig-2.16.0
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
pkgname=fontconfig
pkgver=2.16.0
pkgurl="https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.16.0.tar.xz"
pkgmd5='20d5466544aa62d18c94106faa169a09'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-docs --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
	install -v -dm755 /usr/share/man/man{1,3,5}
	install -v -dm755 /usr/share/doc/$pkgdir
	install -v -m644 fc-*/*.1 /usr/share/man/man1
	install -v -m644 doc/*.3 /usr/share/man/man3
	install -v -m644 doc/fonts-conf.5 /usr/share/man/man5
	install -v -m644 doc/*.{pdf,sgml,txt,html} /usr/share/doc/$pkgdir
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
