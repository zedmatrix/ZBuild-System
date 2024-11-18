#!/bin/bash
RED="\e[1;31m"
GREEN="\e[1;32"
YELLOW="\e[1;33m"
NORMAL="\e[0m"

LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
# Possible breakage in the yasm/nasm building of libvpx-1.15.0
ZBUILD_root="${LFS}/zbuild"
ZBUILD_sources="${LFS}/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_Log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

Src_Extract() {
	print "Extracting: ${archive}"
	mkdir -v "${ZBUILD_root}/${packagedir}"
	tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}

print() { printf "${YELLOW}*** %s ***${NORMAL}\n" "$*"; }

export RED GREEN YELLOW NORMAL
export ZBUILD_root ZBUILD_sources ZBUILD_log ZBUILD_script LFS LFS_TGT
export -f Src_Extract print
