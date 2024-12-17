# Linux From Scratch r12.2-51-systemd

# Mounting qcow Image to /devnbd {network block device}
sudo modprobe nbd max_part=2
`sudo modprobe nbd nbds_max=2 max_part=2`

`sudo qemu-nbd --connect=/dev/nbd0 lfs-source.img`
sudo qemu-nbd --connect=/dev/nbd0 lfs_12_uefi.img

`sudo fdisk -l /dev/nbd0`

`sudo mount /dev/nbd0p1 /mnt/QemuDisk`
`sudo mount /dev/nbd0p3 /mnt/QemuDisk`

`sudo umount /mnt/QemuDisk`
`sudo qemu-nbd --disconnect /dev/nbd0`

# Creating a Qemu Disk Image
```
DISK_IMAGE=linuxfromscratch_dev
DISK_SIZE=50G
qemu-img create -f qcow2 ${DISK_IMAGE}.img ${DISK_SIZE}
```

### example: qemu-img create -f qcow2 XLFS_12-2.img 60G

# Creating ISO from a Source Directory
```
ISO_FILE=cd-source.iso 
DIRECTORY=cd-source/
mkisofs -o ${ISO_FILE} -R -J ${DIRECTORY}
```

### example: mkisofs -o blfs-source.iso -R -J blfs_source/

# Mounting ISO
```
ISO_FILE=cd-source.iso
sudo mount -o loop ${ISO_FILE} /mnt/iso
```

