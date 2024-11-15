#!/bin/bash
RED="\e[1;31m"
GREEN="\e[1;32"
YELLOW="\e[1;33m"
NORMAL="\e[0m"

LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
BUILD_ROOT="${LFS}/BUILD"
BUILD_SOURCE="${LFS}/opt/source"
BUILD_LOG="${BUILD_ROOT}/Zbuild_Logs"
BUILD_CMD="${BUILD_ROOT}/zbuild2.sh"

Src_Extract() {
	print "Extracting: ${archive}"
	mkdir -v "${BUILD_ROOT}/${packagedir}"
	tar -xf "${BUILD_SOURCE}/${archive}" -C "${BUILD_ROOT}/${packagedir}" --strip-components=1
}

print() { printf "${RED}*** ${YELLOW}%s ${RED}***${NORMAL}\n" "$*"; }


export RED GREEN YELLOW NORMAL
export BUILD_CMD BUILD_LOG BUILD_ROOT BUILD_SOURCE LFS LFS_TGT
export -f Src_Extract print
