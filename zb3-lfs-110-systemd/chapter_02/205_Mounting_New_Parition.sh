#!/bin/bash
echo "Setting Up LFS - ZBuild Enironment"
# zbuild 2.0 cross compile environment
LFS="/mnt/lfs"
ZBUILD_root="$LFS/zbuild"
ZBUILD_sources="$LFS/sources"
ZBUILD_log="$ZBUILD_root/Zbuild_log"
ZBUILD_script="$ZBUILD_root/zbuild3.sh"

# change your ROOT and SWAP devices
echo "Setting ROOT and SWAP Partitions"
ROOT=sda3
SWAP=sda2

echo "* Mounting $LFS to /dev/$ROOT *"
if [ -d $LFS ]; then
	mkdir -pv $LFS
fi

echo "*** Mounting $LFS to /dev/$ROOT"
mount -v -t ext4 /dev/$ROOT $LFS

echo "*** Creating $ZBUILD_root "
mkdir -pv $ZBUILD_root

echo "*** Creating $ZBUILD_log "
mkdir -pv $ZBUILD_log

echo "*** Creating $ZBUILD_sources "
mkdir -pv $ZBUILD_sources

echo "*** Setting Up Build Environment Modes"
[ -d $ZBUILD_sources ] && chmod -v a+wt $ZBUILD_sources || echo "Error: setting mode on $ZBUILD_sources"
[ -d $ZBUILD_root ] && chmod -v 755 $ZBUILD_root || echo "Error: setting mode on $ZBUILD_root"

export LFS ZBUILD_root ZBUILD_sources ZBUILD_log ZBUILD_script
echo "* Done - Next Chapter 3 - Download the Sources and Patches *"
