#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	SQLite-3.49.1
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
pkgname=sqlite
pkgver=3.49.1
pkgurl="https://sqlite.org/2025/sqlite-autoconf-3490100.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --disable-static --enable-fts4 --enable-fts5"
zflags="-D SQLITE_ENABLE_COLUMN_METADATA=1 -D SQLITE_ENABLE_UNLOCK_NOTIFY=1"
zflags="${zflags} -D SQLITE_ENABLE_DBSTAT_VTAB=1 -D SQLITE_SECURE_DELETE=1"
#
#   Build Functions
#
Src_prepare() {
	unzip -q /sources/sqlite-doc-3490100.zip || return 99
}
Src_configure() {
    ./configure ${zconfig} CPPFLAGS="${zflags}" || return 88
}
Src_compile() {
    make || return 77
}
Src_install() {
    make install || return 55
	install -v -m755 -d /usr/share/doc/$pkgdir
	cp -v -R sqlite-doc-3490100/* /usr/share/doc/$pkgdir
}
export pkgname pkgver pkgurl pkgdir zdelete zconfig zflags
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
    unset pkgname pkgver pkgurl pkgdir zdelete zconfig zflags
fi
