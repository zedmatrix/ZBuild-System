#!/bin/bash
zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zznormal="${zznormal:-\033[0m}"

LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
LC_ALL=POSIX
LANG=C.UTF-8

ZBUILD_root="${LFS}/zbuild"
ZBUILD_sources="${LFS}/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild3.sh"

zprint() { printf "${zzyellow}*** %s ***${zznormal}\n" "$*"; }

export zzred zzgreen zzyellow zznormal LC_ALL LANG
export ZBUILD_root ZBUILD_sources ZBUILD_log ZBUILD_script LFS LFS_TGT
export -f zprint

[ -f $ZBUILD_script ] && chmod -v +x ${ZBUILD_script} || echo "Error: setting mode on $ZBUILD_script"
