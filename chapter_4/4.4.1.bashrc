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
BUILD_SOURCE=$LFS/opt/source
BUILD_ROOT=$LFS/BUILD
BUILD_LOG=$BUILD_ROOT/Zbuild_Logs
BUILD_CMD="${BUILD_ROOT}/zbuild2.sh"

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
export BUILD_SOURCE BUILD_ROOT BUILD_LOG BUILD_CMD
export -f Src_Extract print

# End of Temporary Build Environment Setup
