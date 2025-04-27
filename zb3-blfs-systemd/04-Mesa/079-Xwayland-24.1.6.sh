#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	Xwayland-24.1.6
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
pkgname=xwayland
pkgver=24.1.6
pkgdir=${pkgname}-${pkgver}
pkgurl="https://www.x.org/pub/individual/xserver/xwayland-24.1.6.tar.xz"
pkgmd5='78067c218323fe2a496ca5f2145fe7ab'
pkgpatch=""
zdelete="true"
#	Meson
zconfig="--prefix=/usr --buildtype=release -D xkb_output_dir=/var/lib/xkb"
#
#   Build Functions
#
Src_prepare() {
	sed -i '/install_man/,$d' meson.build && echo " Patched "
    mkdir -v build
    cd build
}
Src_configure() {
    meson setup .. ${zconfig} || return 88
}
Src_compile() {
    ninja  || return 77
}
Src_check() {
	mkdir -v tools
	pushd tools
	git clone https://gitlab.freedesktop.org/mesa/piglit.git --depth 1
	cat > piglit/piglit.conf << "EOF"
[xts]
path=$(pwd)/xts
EOF
	git clone https://gitlab.freedesktop.org/xorg/test/xts --depth 1
	export DISPLAY=:22
	../hw/vfb/Xvfb $DISPLAY &
	VFB_PID=$!
	cd xts
	CFLAGS=-fcommon ./autogen.sh
	make
	kill $VFB_PID
	unset DISPLAY VFB_PID
	popd
    XTEST_DIR=$(pwd)/tools/xts PIGLIT_DIR=$(pwd)/tools/piglit ninja test 2>&1 | tee "${ZBUILD_log}/${pkgdir}-test.log"
}
Src_install() {
    ninja install || return 55
	install -vm755 hw/vfb/Xvfb /usr/bin
}
export pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgmd5 zdelete zconfig
fi
