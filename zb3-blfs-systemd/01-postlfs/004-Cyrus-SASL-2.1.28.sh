#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Cyrus SASL-2.1.28
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
pkgname=cyrus-sasl
pkgver=2.1.28
pkgurl="https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --sysconfdir=/etc --enable-auth-sasldb --with-dblib=lmdb --with-dbpath=/var/lib/sasl/sasldb2"
zconfig="${zconfig} --with-sphinx-build=no --with-saslauthd=/var/run/saslauthd"
#
#   Build Functions
#
Src_prepare() {
	sed '/saslint/a #include <time.h>' -i lib/saslutil.c && echo " Patched "
	sed '/plugin_common/a #include <time.h>' -i plugins/cram.c && echo " Patched "
}
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make -j1 || return 77
}
Src_install() {
    make install || return 55
	install -v -dm755 /usr/share/doc/$pkgdir/html
	install -v -m644  saslauthd/LDAP_SASLAUTHD /usr/share/doc/$pkgdir
	install -v -m644  doc/legacy/*.html /usr/share/doc/$pkgdir
	install -v -dm700 /var/lib/sasl
	echo " From BLFS-Systemd Units: make install-saslauthd "
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
