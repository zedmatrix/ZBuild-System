zprint "Mounting ESP/EFI System Partition"
mount --mkdir -v -t vfat /dev/sda1 -o codepage=437,iocharset=iso8859-1 /boot/efi

zprint "Appending /etc/fstab for ESP/EFI System Partition"
cat >> /etc/fstab << EOF
    /dev/sda1 /boot/efi vfat codepage=437,iocharset=iso8859-1 0 1
EOF

zprint "Installing GRUB for EFI"
grub-install --target=x86_64-efi --removable

zprint "Mounting /sys/firmware/efi/efivarfs"
mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
grub-install --bootloader-id=LFS --recheck

zprint "UEFI Boot Manager Check"
efibootmgr | cut -f 1

zprint "Done"
