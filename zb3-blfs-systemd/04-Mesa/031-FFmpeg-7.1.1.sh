#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	FFmpeg-7.1.1
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
pkgname=ffmpeg
pkgver=7.1.1
pkgurl="https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz"
pkgmd5='26f2bd7d20c6c616f31d7130c88d7250'
pkgpatch="ffmpeg-7.1.1-chromium_method-1.patch"
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="--prefix=/usr --disable-debug --disable-static --enable-shared --docdir=/usr/share/doc/$pkgdir"
zconfig="${zconfig} --enable-gpl --enable-version3 --enable-nonfree --enable-libaom --enable-libass --enable-libfdk-aac"
zconfig="${zconfig} --enable-libvpx --enable-libx264 --enable-libx265 --enable-openssl --ignore-tests=enhanced-flv-av1"
zconfig="${zconfig} --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libdav1d"
#
#   Build Functions
#
Src_configure() {
    ./configure ${zconfig} || return 88
}
Src_compile() {
    make || return 77
	gcc tools/qt-faststart.c -o tools/qt-faststart
	doxygen doc/Doxyfile
}
Src_check() {
    make install || return 55
	install -v -m755 tools/qt-faststart /usr/bin
}
Src_install() {
	make fate-rsync SAMPLES=fate-suite/
	rsync -vrltLW  --delete --timeout=60 --contimeout=60 rsync://fate-suite.ffmpeg.org/fate-suite/ fate-suite/
	make fate THREADS=$(nproc) SAMPLES=fate-suite/ 2>&1 | tee "${ZBUILD_log}/${pkgdir}-check.log"
}
Src_post() {
	grep ^TEST "${ZBUILD_log}/${pkgdir}-check.log" | wc -l
}
export pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
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
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_check
    unset -f Src_install
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir pkgmd5 pkgpatch zdelete zconfig
fi
