# Building Linux From Scratch
## Development Version r12.2-82 Systemd
### Download and Prepare a Gentoo Root
To aide in your development of Linux From Scratch 
First thing I did to start my journey was using the <br>
Gentoo Live CD https://www.gentoo.org/downloads/<br>

Choose the Minimum Live CD and a Stage 3 File to Begin<br>
[Gentoo Live Min Cd](https://www.dropbox.com/scl/fi/w7x1sq6ebuhxuyynrrrh2/install-amd64-minimal-20241013T160327Z.iso?rlkey=o56xmeefkfwpszl3qmkehwmwq&st=r6md781c&dl=0)
<br>
[Gentoo Stage 3](https://www.dropbox.com/scl/fi/obtam8x7jv8hconcpixbu/stage3-amd64-systemd-20241013T160327Z.tar.xz?rlkey=f8g92ok3n39iwoliqzjzgpydz&st=c8a28wc5&dl=0)
<br>
* You can either burn the Live CD or Write it to a USB
* Once Booted into the Live CD Enviroment.
* Mount a USB for the Gentoo Root FS `mount /dev/sdX /mnt/gentoo && cd /mnt/gentoo`
* Now Download the stage 3 file and extract.
```
wget [Gentoo Stage 3]
tar -xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```
* Now copy over the resolv.conf
   ` cp -v --dereference /etc/resolv.conf /mnt/gentoo/etc/ `
* or Create a simple one like:
```
cat > /mnt/gentoo/etc/resolv.conf << EOF
nameserver 1.1.1.1
EOF
```
* Mount Virtual Filesystems and chroot into the build root environment
```
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
