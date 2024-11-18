echo "* De-Initializing Gentoo Root"
gentoo=/mnt/gentoo
#mkdir -pv $gentoo

umount -v -l $gentoo/dev{/shm,/pts}
umount -v -l $gentoo/sys
umount -v $gentoo/proc
umount -v $gentoo/run
umount -R $gentoo

echo "* Done"
