#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	XviD-1.3.7
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
pkgname=xvidcore
pkgver=1.3.7
pkgurl="https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.gz"
pkgmd5='5c6c19324608ac491485dbb27d4da517'
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
/usr/share/doc/$pkgdir
#
#   Build Functions
#
Src_prepare() {
    cd build/generic
	sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in && echo " Patched "
}
Src_configure() {
    ./configure --prefix=/usr || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
	sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile && echo " Patched "
    make install || return 55
	chmod -v 755 /usr/lib/libxvidcore.so.4.3
	install -v -m755 -d /usr/share/doc/$pkgdir/examples
	install -v -m644 ../../doc/* /usr/share/doc/$pkgdir
	install -v -m644 ../../examples/* /usr/share/doc/$pkgdir/examples
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
export -f Src_prepare
export -f Src_configure
export -f Src_compile
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
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete
fi
