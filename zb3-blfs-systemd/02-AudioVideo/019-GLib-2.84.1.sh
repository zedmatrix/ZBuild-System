#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	GLib-2.84.1
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
pkgname=glib
pkgver=2.84.1
pkgurl="https://download.gnome.org/sources/glib/2.84/glib-2.84.1.tar.xz"
pkgmd5='7befc5809f28b092c662d00533b017c2'
pkgpatch="glib-skip_warnings-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --buildtype=release -D introspection=disabled -D glib_debug=disabled"
zconfig="${zconfig} -D man-pages=enabled -D sysprof=disabled"
#
#   Build Functions
#
Src_prepare() {
    mkdir -v build
    cd build
}
Src_configure() {
    meson setup .. ${zconfig}
	ninja || return 88
	ninja install
}
Src_compile() {
	tar xf /sources/gobject-introspection-1.84.0.tar.xz || return 77
	meson setup gobject-introspection-1.84.0 gi-build --prefix=/usr --buildtype=release
	ninja -C gi-build || return 77
}
Src_check() {
	ninja -C gi-build test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
    ninja -C gi-build install
}
Src_install() {
	meson configure -D introspection=enabled &&
	ninja
	chown -R tester .
    su tester -s /bin/bash -c "LC_ALL=C ninja test" 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
    ninja install || return 55
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
fi
