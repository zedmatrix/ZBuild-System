# Linux From Scratch r12.2-51-systemd <br>

## Mounting Qemu Disk Image <br>
  to /dev/nbd {network block device}
<br>

Sets up network block 2 devices 4 partitions <br>
```
sudo modprobe nbd nbds_max=2 max_part=4
lsblk
```

Connect your qemu image to a network block device <br>

`sudo qemu-nbd --connect=/dev/nbd0 qemu-image-file` <br>

example: `sudo qemu-nbd --connect=/dev/nbd0 lfs_12_uefi.img` <br>

Check the partitions available <br>
```
sudo fdisk -l /dev/nbd0
```

Mounting Partition to Local Folder <br>
```
sudo mount /dev/nbd0p1 /mnt/QemuDisk
sudo mount /dev/nbd0p3 /mnt/QemuDisk
```

Unmount and Disconnect
```
sudo umount /mnt/QemuDisk
sudo qemu-nbd --disconnect /dev/nbd0
```
<hr>

# Creating a Qemu Disk Image
```
DISK_IMAGE=linuxfromscratch_dev
DISK_SIZE=50G
qemu-img create -f qcow2 ${DISK_IMAGE}.img ${DISK_SIZE}
```
example: `qemu-img create -f qcow2 XLFS_12-2.img 60G`

# Creating ISO from a Source Directory
```
ISO_FILE=cd-source.iso 
DIRECTORY=cd-source/
mkisofs -o ${ISO_FILE} -R -J ${DIRECTORY}
```

<br> example: `mkisofs -o blfs-source.iso -R -J blfs_source/` <br>

# Mounting a CDROM Image File
```
ISO_FILE=cd-source.iso
sudo mount -o loop ${ISO_FILE} /mnt/iso
```
