#!/bin/bash
# A Simple Bash Script to Start a qemu vm
System="-M pc-q35-8.2 -enable-kvm -m 8G -smp 4"
# this is copied from OVMF.fd and renamed to LFS_UEFI.flash to boot UEFI Mode
UEFI="-drive if=pflash,format=raw,file=LFS_UEFI.flash"

# create like> qemu-img create -f qcow2 lfs_12_uefi.img 50G
LFS="-drive id=disk0,if=none,format=qcow2,file=lfs_12_uefi.img -device virtio-blk-pci,drive=disk0,bootindex=0"
# a scratch drive created in a similar way and you can restrict to smaller size like 3G
Source="-drive id=disk1,if=none,format=qcow2,file=lfs-source.img -device virtio-blk-pci,drive=disk1,bootindex=1"

# LFS Source CD Rom created from the host> mkisofs -o lfs-source.iso -R -J lfs_files/
LFSsource="-drive file=lfs-source.iso,media=cdrom"
# BLFS Source CD Rom created from the host> mkisofs -o blfs-source.iso -R -J blfs_files/
BLFSsource="-drive file=blfs-source.iso,media=cdrom"

# the Gentoo Live CD and Writable Drive like a usb 
GENTOO="-drive id=cd0,if=none,format=raw,readonly=on,file=Live_Gentoo_Min.iso -device ide-cd,bus=ide.1,drive=cd0,bootindex=2"
# created for downloading the stage 3 tar and extracting to 
# qemu-img create -f qcow2 Gen_Root.img 3G
GenRoot="-drive id=disk1,if=none,format=qcow2,file=Gen_Root.img -device virtio-blk-pci,drive=disk1,bootindex=1"

# some global options to start the qemu VM
Logfile="-global isa-debugcon.iobase=0x402 -debugcon file:gentoo.ovmf.log"
Monitor="-monitor stdio"
Serial="-serial mon:stdio"
Mouse="-device piix3-usb-uhci -device usb-tablet"
Network="-netdev user,id=net0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0,romfile="
Video="-device qxl-vga,xres=1440,yres=900"
# Still a work in progress and experimenting with spice
Spice="-spice port=5900,addr=127.0.0.1,disable-ticketing=on -device virtio-serial-pci -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent"
# Mount USB drive ... for me this required sudo 
USB="-drive file=/dev/sdf,media=disk"
# This starts the qemu vm with the options you select 
# Needed: $System $UEFI $Logfile $Monitor $Mouse $Network $Video 
# Plus: ONE Bootable Drive
qemu-system-x86_64 $System $UEFI $LFS $Source $GENTOO $GenRoot $Logfile $Monitor $Mouse $Network $Video
