#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	libxml2-2.13.6
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
pkgname=libxml2
pkgver=2.13.6
pkgurl="https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.6.tar.xz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --sysconfdir=/etc --disable-static --with-history --with-icu"
zconfig="${zconfig} PYTHON=/usr/bin/python3 --docdir=/usr/share/doc/$pkgdir"
#
#   Build Functions
#
Src_prepare() {
	wget -T 30 -t 5 -c -nc -P /sources https://www.w3.org/XML/Test/xmlts20130923.tar.gz || return 99
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
	tar xf /sources/xmlts20130923.tar.gz
    make check 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_install() {
    make install || return 55
	rm -vf /usr/lib/libxml2.la
	sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config && echo " Patched "
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
