#!/bin/bash

printf "\n\t *** unmounting Kernel Filesystems ***\n\n"
LFS=/mnt/lfs

umount -v $LFS/sys/firmware/efi/efivars
umount -v $LFS/dev/pts
mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

printf "\n\t *** unmount LFS Filesystems *** \n"
cd
umount -v $LFS/boot/efi
umount -v $LFS/home
umount -v $LFS

printf "\n\t *** The End *** \n"

