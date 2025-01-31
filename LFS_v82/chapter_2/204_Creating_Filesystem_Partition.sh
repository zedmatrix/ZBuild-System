#!/bin/bash
echo "Formatting/Creating Paritions"
# zbuild 2.0 cross compile environment

echo "Setting ROOT and SWAP Partitions"
ROOT=sda3
SWAP=sda2
BOOT=sda1

if blkid /dev/$ROOT | grep -q 'TYPE="ext4"'; then
    echo "/dev/$ROOT is already formatted as ext4."
else
    echo "*** Formatting /dev/$ROOT as ext4"
    mkfs.ext4 /dev/$ROOT
fi

if blkid /dev/$BOOT | grep -q 'TYPE="vfat"'; then
    echo "/dev/$BOOT is already formatted as vfat."
else
    echo "*** Formatting /dev/$BOOT as vfat "
    mkfs.vfat /dev/$BOOT
fi

if blkid /dev/$SWAP | grep -q 'TYPE="swap"'; then
    echo "/dev/$SWAP is already formatted as swap."
else
    echo "*** Creating Swap space /dev/$SWAP "
    mkswap /dev/$SWAP
    swapon
fi

echo "* Done - Partitions Formatted *"
