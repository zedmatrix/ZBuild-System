# Preparing the System

>   Start Up fdisk
prepare: `fdisk /dev/sda`
create: `p - n - p - 1 - {enter} - {enter} - w`
print table, new partition, primary, first partition, start, end all
write out partition and exit

# Formatting
`mkfs -v -t ext4 /dev/sda1`

# Setting Environment - stage1
`export LFS=/mnt/lfs`
`umask 022`
`mkdir -pv $LFS`
`mount /dev/sda1 $LFS`

## Create Limited Directory Layout 
>Files
    0-environment.sh<br>
    1-limited-dir.sh<br>

## Getting Packages for Limited Toolchain
>File: 2-limited-packages.sh

## Compiling Cross Toolchain - stage2
### Chapter 5 LFS Book System-V
>Files: 
    5.1-binutils-2.44.sh<br>
    5.2-gcc-15.1.0.sh<br>
    5.3-linux-6.6.93.sh<br>
    5.4-musl-1.2.5.sh<br>
    5.5-Libstdcpp.sh<br>
    
## Chapter 6 - stage2
>Files:
    6.1-m4-1.4.20.sh<br>
    6.2-ncurses-6.5.sh<br>
    6.3-bash-5.3-rc2.sh<br>
    6.4-coreutils-9.7.sh<br>
    6.5-diffutils-3.12.sh<br>
    6.6-file-5.46.sh<br>
    6.7-findutils-4.10.0.sh<br>
    6.8-gawk-5.3.2.sh<br>
    6.9-grep-3.12.sh<br>
    6.10-gzip-1.14.sh<br>
    6.11-make-4.4.1.sh<br>
    6.12-patch-2.8.sh<br>
    6.13-sed-4.9.sh<br>
    6.14-tar-1.35.sh<br>
    6.15-xs-5.8.1.sh<br>
    6.16-binutils-2.44.sh<br>
    6.17-gcc-15.1.0.sh<br>
    
## Chapter 7 - Chroot and Finish Toolchain
>Files:
    7.1-zlfs-chroot.sh<br>
    7.2-dirs-files-symlinks.sh<br>
    7.3-gettext-0.25.sh<br>
    7.4-bison-3.8.2.sh<br>
    7.5-perl-5.40.2.sh<br>
    7.6-Python-3.13.5.sh<br>
    7.7-texinfo-7.2.sh<br>
    7.8-util-linux-2.41.sh<br>
    
>   Cleanup
    `rm -rf /usr/share/{info,man,doc}/*`<br>
    `find /usr/{lib,libexec} -name \*.la -delete`<br>
    `rm -rf /tools`<br>
    
>   Saving Temporary System
    `exit && cd $LFS`<br>
    `tar --exclude=/{sources,zbuild} -cJpf /home/lfs-musl-temptools-r12.3-71.tar.xz .`<br>

## Chapter 8 - Basic System - stage3
>   Finish Downloading Sources
    `wget -c -nc -P $LFS/sources -i wget-list-sysv`<br>
    
### Book Version Version r12.3-71
[Linux From Scratch](https://www.linuxfromscratch.org/lfs/view/development/)
