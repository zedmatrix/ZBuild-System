#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Rustc-1.86.0
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
pkgname=rustc
pkgver=1.86.0
pkgurl="https://static.rust-lang.org/dist/rustc-1.86.0-src.tar.xz"
pkgmd5='ffe55dfd0e035e6bfc88060506cddf32'
pkgpatch=""
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="$PWD/021-config.toml"
#
#   Build Functions
#
Src_prepare() {
	mkdir -pv /opt/$pkgdir
	ln -svfn $pkgdir /opt/rustc
	cp -v $zconfig config.toml
}
Src_configure() {
	return 0
}
Src_compile() {
	[ ! -e /usr/include/libssh2.h ] || export LIBSSH2_SYS_USE_PKG_CONFIG=1
	[ ! -e /usr/include/sqlite3.h ] || export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	./x.py build
}
Src_check() {
    ./x.py test --verbose --no-fail-fast | tee "${ZBUILD_log}/${pkgdir}-test.log"

}
Src_install() {
	./x.py install rustc std
	./x.py install --stage=1 cargo clippy rustfmt
	rm -fv /opt/$pkgdir/share/doc/$pkgdir/*.old
	install -vm644 README.md /opt/$pkgdir/share/doc/$pkgdir
	install -vdm755 /usr/share/zsh/site-functions
	ln -sfv /opt/rustc/share/zsh/site-functions/_cargo /usr/share/zsh/site-functions
	mv -v /etc/bash_completion.d/cargo /usr/share/bash-completion/completions
	unset LIB{SSH2,SQLITE3}_SYS_USE_PKG_CONFIG
}
Src_post() {
	grep '^test result:' ${ZBUILD_log}/${pkgdir}-test.log |
 awk '{sum1 += $4; sum2 += $6} END { print sum1 " passed; " sum2 " failed" }'
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
export -f Src_prepare
export -f Src_configure
export -f Src_compile
export -f Src_check
export -f Src_install
export -f Src_post

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
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
fi
