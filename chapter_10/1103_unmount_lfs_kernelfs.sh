zprint "unmounting Kernel Filesystems"
umount -v $LFS/dev/pts
mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

zprint "unmount LFS Filesystems"
cd
umount -v $LFS/boot/efi
umount -v $LFS/home
umount -v $LFS

zprint "Done"
