#!/bin/bash
printf "\n\t Mounting ESP/EFI System Partition \n"
BOOT=/dev/sda1
mount --mkdir -v -t vfat $BOOT -o codepage=437,iocharset=iso8859-1 /boot/efi

printf "\t Installing GRUB for EFI \n"
grub-install --target=x86_64-efi --removable

printf "\t Mounting /sys/firmware/efi/efivarfs \n"
mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
grub-install --bootloader-id=LFS --recheck

printf "\t UEFI Boot Manager Check \n"
efibootmgr | cut -f 1

printf " \t *** Done *** \n"
