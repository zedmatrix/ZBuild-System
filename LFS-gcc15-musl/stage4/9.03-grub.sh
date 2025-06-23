#!/bin/bash

# Setup GRUB Partition
grub-install /dev/sda

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,1)
set gfxpayload=1024x768x32

menuentry "GNU/Linux, Linux 6.6.93-lfs-r12.3-71" {
    linux   /boot/vmlinuz-6.6.93 root=/dev/sda1 rw
}
EOF
