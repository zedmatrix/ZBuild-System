#!/bin/bash
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
BUILD_SOURCE=$LFS/opt/source
BUILD_ROOT=$LFS/BUILD
BUILD_LOGS=$BUILD_ROOT/Zbuild_Logs
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export MAKEFLAGS=-j$(nproc)
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export BUILD_SOURCE BUILD_ROOT BUILD_LOGS
