#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	LLVM-20.1.1
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
pkgname=LLVM
pkgver=20.1.1
pkgurl="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.1/llvm-20.1.1.src.tar.xz"
pkgmd5='4dded37d4e2a030793de925ed6894eb6'
pkgpatch=""
pkgsrc='/sources'
zdelete="true"
pkgdir=${pkgname}-${pkgver}
zconfig="-D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release -D CMAKE_SKIP_INSTALL_RPATH=ON"
zconfig="${zconfig} -D LLVM_ENABLE_FFI=ON -D LLVM_BUILD_LLVM_DYLIB=ON -D LLVM_LINK_LLVM_DYLIB=ON"
zconfig="${zconfig} -D LLVM_ENABLE_RTTI=ON -D LLVM_BINUTILS_INCDIR=/usr/include -D LLVM_INCLUDE_BENCHMARKS=OFF"
zconfig="${zconfig} -D CLANG_DEFAULT_PIE_ON_LINUX=ON -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang -W no-dev -G Ninja"
zconfig="${zconfig} -D LLVM_TARGETS_TO_BUILD="
#
#   Build Functions
#
Src_prepare() {
	tar -xf $pkgsrc/llvm-cmake-20.1.1.src.tar.xz || return 99
	tar -xf $pkgsrc/llvm-third-party-20.1.1.src.tar.xz || return 99
	sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-20.1.1.src@' -i CMakeLists.txt && echo " Patched "
	sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-20.1.1.src@' -i cmake/modules/HandleLLVMOptions.cmake
	tar -xf $pkgsrc/clang-20.1.1.src.tar.xz -C tools || return 99
	mv tools/clang-20.1.1.src tools/clang
	tar -xf $pkgsrc/compiler-rt-20.1.1.src.tar.xz -C projects || return 99
	mv projects/compiler-rt-20.1.1.src projects/compiler-rt
	grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
	sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt
}
Src_configure() {
    mkdir -v build
    cd build
	CC=gcc CXX=g++ cmake .. ${zconfig}"host;AMDGPU" || return 88
}
Src_compile() {
    ninja  || return 77
}
Src_check() {
	sed -e 's/config.has_no_default_config_flag/True/' -e 's/"-fuse-ld=gold"//' \
	-i ../projects/compiler-rt/test/lit.common.cfg.py && echo " Patched "
	systemctl   --user start dbus
	systemd-run --user --pty -d -G -p LimitCORE=0 ninja check-all 2>&1 | tee "${ZBUILD_log}/${pkgdir}-test.log"
}
Src_install() {
    ninja install || return 55
	mkdir -pv /etc/clang &&
	for i in clang clang++; do
	  echo -fstack-protector-strong > /etc/clang/$i.cfg
	done
}
export pkgname pkgver pkgurl pkgdir pkgsrc pkgmd5 zdelete zconfig
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
    unset pkgname pkgver pkgurl pkgdir pkgsrc pkgmd5 zdelete zconfig
fi
