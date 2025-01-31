zprint "unmounting Host Build Kernel Filesystems"
gentoo=/mnt/gentoo
umount -v -l $gentoo/dev{/shm,/pts}
umount -v -l $gentoo/sys
umount -v $gentoo/proc
umount -v $gentoo/run


zprint "unmount Host Build Filesystems"
cd
umount -R $gentoo

zprint "Done"
