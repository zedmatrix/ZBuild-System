#!/bin/bash
#       Install Zbuild v3.4 - LFS - Temporary System
#	6.3. Ncurses-6.5
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
pkgname=ncurses
pkgver=6.5
pkgurl="https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
zconfig="--prefix=/usr --host=$LFS_TGT --mandir=/usr/share/man --with-manpage-format=normal --with-shared"
zconfig="${zconfig} --without-normal --with-cxx-shared --without-debug --without-ada --disable-stripping AWK=gawk"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    pushd build
      ../configure AWK=gawk
	  make -C include
	  make -C progs tic
	popd
}
Src_configure() {
    ./configure --build=$(./config.guess) ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install || return 55
    ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h && echo " Patched "
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
