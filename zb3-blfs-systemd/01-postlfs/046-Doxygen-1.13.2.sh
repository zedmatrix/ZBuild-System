#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Doxygen-1.13.2
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
pkgname=doxygen
pkgver=1.13.2
pkgurl="https://doxygen.nl/files/doxygen-1.13.2.src.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="-D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release -D build_wizard=OFF"
zconfig="${zconfig} -D force_qt=Qt6 -W no-dev"
#
#   Build Functions
#
Src_prepare() {
	grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'
    mkdir -v build
    cd build
}
Src_configure() {
    cmake .. -G "Unix Makefiles" ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make tests 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
	cmake .. -D build_doc=ON -D DOC_INSTALL_DIR=share/doc/$pkgdir
	make docs
}
Src_install() {
    make install || return 55
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
