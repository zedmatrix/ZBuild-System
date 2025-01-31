# 11 Rebooting

Install any firmware needed if the kernel driver for your hardware requires some firmware files to function properly.

Ensure a password is set for the root user.

A review of the following configuration files is also appropriate at this point.

    /etc/bashrc
    /etc/dircolors
    /etc/fstab
    /etc/hosts
    /etc/inputrc
    /etc/profile
    /etc/resolv.conf
    /etc/vimrc
    /root/.bash_profile
    /root/.bashrc

Now that we have said that, let's move on to booting our shiny new LFS installation for the first time! 
First exit from the chroot environment: `logout`

 Then unmount the virtual file systems:

    umount -v $LFS/dev/pts
    mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
    umount -v $LFS/dev
    umount -v $LFS/run
    umount -v $LFS/proc
    umount -v $LFS/sys

If multiple partitions were created, unmount the other partitions before unmounting the main one, like this:

    umount -v $LFS/boot/efi
    umount -v $LFS/home
    umount -v $LFS

Unmount the LFS file system itself:

    cd
    umount -v $LFS

If you mount a stage host build environment:
Exit from that environment as well: `exit`

Also unmount the Host Build System:

    gentoo=/mnt/gentoo
    umount -v -l $gentoo/dev{/shm,/pts}
    umount -v -l $gentoo/sys
    umount -v $gentoo/proc
    umount -v $gentoo/run
    umount -R $gentoo
    
Now, reboot the system.

# 11 Firmware

Extra Scripts to install firmware
