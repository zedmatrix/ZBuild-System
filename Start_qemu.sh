System="-M pc-q35-8.2 -enable-kvm -m 8G -smp 4"

UEFI="-drive if=pflash,format=raw,file=LFS_UEFI.flash"
LFS="-drive id=disk0,if=none,format=qcow2,file=lfs_12_uefi.img -device virtio-blk-pci,drive=disk0,bootindex=0"
LFSsource="-drive id=disk1,if=none,format=qcow2,file=lfs-source.img -device virtio-blk-pci,drive=disk1,bootindex=1"
XLFS="-drive id=disk2,if=none,format=qcow2,file=XLFS_12-2.img -device virtio-blk-pci,drive=disk2,bootindex=2"

GenRoot="-drive id=disk1,if=none,format=qcow2,file=Gen_Root.img -device virtio-blk-pci,drive=disk1,bootindex=1"
GENTOO="-drive id=cd0,if=none,format=raw,readonly=on,file=Live_Gentoo_Min.iso -device ide-cd,bus=ide.1,drive=cd0,bootindex=2"

#LFS Source CD Rom
#Source="-drive file=cd-source.iso,media=cdrom"

#BLFS Source CD Rom
Source="-drive file=blfs-source.iso,media=cdrom"

#Mount USB drive
USB="-drive file=/dev/sdf,media=disk"

#Suspend="-global PIIX4_PM.disable_s3=0"
Logfile="-global isa-debugcon.iobase=0x402 -debugcon file:gentoo.ovmf.log"
Monitor="-monitor stdio"
Serial="-serial mon:stdio"
Mouse="-device piix3-usb-uhci -device usb-tablet"
Network="-netdev user,id=net0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0,romfile="

Video="-device qxl-vga,xres=1440,yres=900"

#Video="-vga qxl -display gtk,gl=on"

Spice="-spice port=5900,addr=127.0.0.1,disable-ticketing=on -device virtio-serial-pci -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent"

#Spice="-spice port=5900,disable-ticketing=on"
#Clipboard="-device virtio-serial-pci -chardev spicevmc,id=vdagent,debug=0,name=vdagent -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"

qemu-system-x86_64 $System $UEFI $LFS $LFSsource $Logfile $Monitor $Mouse $Network $Video
