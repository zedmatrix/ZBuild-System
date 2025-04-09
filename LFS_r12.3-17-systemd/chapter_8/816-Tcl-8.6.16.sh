#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.16. Tcl-8.6.16
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
pkgname=tcl
pkgver=8.6.16
pkgurl="https://downloads.sourceforge.net/tcl/tcl8.6.16-src.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --mandir=/usr/share/man --disable-rpath"
#
#   Build Functions
#
Src_configure() {
	SRCDIR=$(pwd)
	cd unix
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
    sed -e "s|$SRCDIR/unix|/usr/lib|" -e "s|$SRCDIR|/usr/include|" \
    -i tclConfig.sh && echo " Patched "

	sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|"  -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|" -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|" \
    -i pkgs/tdbc1.1.10/tdbcConfig.sh && echo " Patched "

	sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|" -i pkgs/itcl4.3.2/itclConfig.sh && echo " Patched "
    unset SRCDIR
}
Src_check() {
    make test 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"
}
Src_install() {
    make install || return 55
    chmod -v u+w /usr/lib/libtcl8.6.so
    make install-private-headers
    ln -sfv tclsh8.6 /usr/bin/tclsh
    mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
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
