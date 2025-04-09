#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#	8.17. Expect-5.45.4
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
pkgname=expect
pkgver=5.45.4
pkgurl="https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz"
pkgpatch="expect-5.45.4-gcc14-1.patch"
zdelete="true"
#   Configure
zconfig="--prefix=/usr --with-tcl=/usr/lib --enable-shared --disable-rpath --mandir=/usr/share/man --with-tclinclude=/usr/include"
#
#   Build Functions
#
Src_prepare() {
	python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make test 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"
}
Src_install() {
    make install || return 55
    ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
}
export pkgname pkgver pkgurl pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgpatch zdelete zconfig
fi
