echo "* Initializing Gentoo Root"
gentoo=/mnt/gentoo
#mkdir -pv $gentoo

mount -v --types proc /proc $gentoo/proc
mount -v --rbind /sys $gentoo/sys
mount -v --make-rslave $gentoo/sys
mount -v --rbind /dev $gentoo/dev
mount -v --make-rslave $gentoo/dev
mount -v --bind /run $gentoo/run
mount -v --make-slave $gentoo/run

echo "* Done"
