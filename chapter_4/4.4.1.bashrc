#!/bin/bash
# Start of Temporary Build Environment Setup
set +h
umask 022
RED="\e[1;31m"
GREEN="\e[1;32"
YELLOW="\e[1;33m"
NORMAL="\e[0m"

LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
ZBUILD_root="${LFS}/BUILD"
ZBUILD_sources="${LFS}/opt/source"
ZBUILD_log="${ZBUILD_root}/Zbuild_Log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

PATH=/usr/bin

if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
Src_Extract() {
	print "Extracting: ${archive}"
	mkdir -v "${BUILD_ROOT}/${packagedir}"
	tar -xf "${BUILD_SOURCE}/${archive}" -C "${BUILD_ROOT}/${packagedir}" --strip-components=1
}

print() { printf "${YELLOW}*** %s ***${NORMAL}\n" "$*"; }

export MAKEFLAGS=-j$(nproc)
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export ZBUILD_root ZBUILD_sources ZBUILD_log ZBUILD_script
export -f Src_Extract print

# End of Temporary Build Environment Setup
