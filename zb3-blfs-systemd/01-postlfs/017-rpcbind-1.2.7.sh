#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	rpcbind-1.2.7
#	DEPEND(libtirpc-1.3.6)
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
pkgname=rpcbind
pkgver=1.2.7
pkgurl="https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.7.tar.bz2"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --bindir=/usr/sbin --enable-warmstarts --with-rpcuser=rpc"
#
#   Build Functions
#
Src_prepare() {
	groupadd -g 28 rpc
	useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc -s /bin/false -u 28 rpc
	sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c && echo " Patched "
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
	systemctl enable rpcbind
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig
fi
