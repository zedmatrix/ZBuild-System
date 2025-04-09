#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	8.58. Coreutils-9.6
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
pkgname=coreutils
pkgver=9.6
pkgurl="https://ftp.gnu.org/gnu/coreutils/coreutils-9.6.tar.xz"
pkgpatch="coreutils-9.6-i18n-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --enable-no-install-program=kill,uptime"
#
#   Build Functions
#
Src_prepare() {
	autoreconf -fv
	automake -af
}
Src_configure() {
	FORCE_UNSAFE_CONFIGURE=1 ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
}
Src_check() {
    make NON_ROOT_USERNAME=tester check-root 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
    groupadd -g 102 dummy -U tester
    chown -R tester .
    su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" < /dev/null
    groupdel dummy
}
Src_install() {
    make install || return 55
    mv -v /usr/bin/chroot /usr/sbin
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
	sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
}
export pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgpatch zdelete zconfig
fi
