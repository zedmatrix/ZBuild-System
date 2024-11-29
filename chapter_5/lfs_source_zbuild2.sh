#!/bin/bash
RED="${RED:-\033[1;31m}"
GREEN="${GREEN:-\033[1;32m}"
YELLOW="${YELLOW:-\033[1;33m}"
NORMAL="${NORMAL:-\033[0m}"

LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
LC_ALL=POSIX
LANG=C.UTF-8

ZBUILD_root="${LFS}/zbuild"
ZBUILD_sources="${LFS}/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

zprint() { printf "${YELLOW}*** %s ***${NORMAL}\n" "$*"; }

Source_wget() {
        if [ -z $1 ]; then
                echo "Atleast one argument is needed"
        else
                wget $1 --no-clobber --rejected-log=${ZBUILD_log}/wget_rejects.log -P ${ZBUILD_sources}
        fi
}

export RED GREEN YELLOW NORMAL
export ZBUILD_root ZBUILD_sources ZBUILD_log ZBUILD_script LFS LFS_TGT
export -f zprint Source_wget
