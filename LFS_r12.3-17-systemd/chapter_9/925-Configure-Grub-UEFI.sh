#!/bin/bash
printf "\n\t *** Creating UEFI grub.cfg - Linux-6.13.7-lfs *** \n"
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,3)

insmod efi_gop
insmod efi_uga
if loadfont /boot/grub/fonts/unicode.pf2; then
    terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 6.13.7-lfs-12.3-17-systemd" {
    linux   /boot/vmlinuz-6.13.7 root=/dev/sda3 ro
}

menuentry "Firmware Setup" {
    fwsetup
}
EOF
printf "\n\t *** Done - Linux 6.13.7-lfs-12.3-17-systemd *** \n"
