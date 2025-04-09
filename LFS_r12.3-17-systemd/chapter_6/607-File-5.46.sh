#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	6.7. File-5.46
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
LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
ZBUILD_root=${LFS}/zbuild
ZBUILD_script=${ZBUILD_root}/zbuild_lfs.sh
ZBUILD_log=${ZBUILD_root}/Zbuild_log
[ ! -d ${ZBUILD_root} ] && { echo "Error: ${ZBUILD_root} directory Missing. Exiting."; exit 2; }
[ ! -d ${ZBUILD_log} ] && mkdir -v $ZBUILD_log
[ ! -f ${ZBUILD_script} ] && { echo "ERROR: Missing ${ZBUILD_script}. Exiting."; exit 3; }

# pkgurl = archive
pkgname=file
pkgver=5.46
pkgurl="https://astron.com/pub/file/file-5.46.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
zconfig="--disable-bzlib --disable-libseccomp --disable-xzlib --disable-zlib"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    pushd build
    ../configure ${zconfig}
    make
    popd
}
Src_configure() {
    ./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess) || return 88
}
Src_compile() {
    make FILE_COMPILE=$(pwd)/build/src/file || return 77
}
Src_install() {
    make DESTDIR=$LFS install || return 55
    rm -v $LFS/usr/lib/libmagic.la
}
export pkgname pkgver pkgurl zdelete zconfig
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
    unset pkgname pkgver pkgurl zdelete zconfig
fi
