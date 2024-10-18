## Building Linux From Scatch 
### Download and Prepare a Gentoo Root
To aide in your development of Linux From Scratch 
First thing I did to start my journey was using the Gentoo Live CD https://www.gentoo.org/downloads/<br>
#
I choose the minimum live cd: 
<br>https://distfiles.gentoo.org/releases/amd64/autobuilds/20241013T160327Z/install-amd64-minimal-20241013T160327Z.iso<br>
As well as a minimum stage 3 for the root about 232Mb.<br>
https://distfiles.gentoo.org/releases/amd64/autobuilds/20241013T160327Z/stage3-amd64-systemd-20241013T160327Z.tar.xz
#
Next you now have booted into your system ready to build i've started by downloading the stage 3 archive <br>
and extracting it to a USB drive which will become your "build system".
#
At this point extract the tar onto the USB and you can use the Gentoo instructions to chroot into that:
You can mount your USB as `mount /dev/sdX /mnt/gentoo`
```
wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20241013T160327Z/stage3-amd64-systemd-20241013T160327Z.tar.xz
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```
Now You have a Build Environment that is when you execute the `./version-check.sh` should give you all OK.
## Start Your LFS Journey
### ZBuild Bash Script
This Follows the book chapters and you can modifiy each zbuild file to follow the book and to aide in upgrading in the future.
With most of the files `chmod +x <somefile>.zbuild` you can execute them with ease.



