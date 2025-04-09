#!/bin/bash
if [ -v LFS ] && [ -n "$LFS" ]; then
   printf "\n\t  Mounting Virtual Kernel Filesystems \n"
   mount -v --bind /dev $LFS/dev
   mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
   mount -vt proc proc $LFS/proc
   mount -vt sysfs sysfs $LFS/sys
   mount -vt tmpfs tmpfs $LFS/run
   if [ -h $LFS/dev/shm ]; then
     install -v -d -m 1777 $LFS$(realpath /dev/shm)
   else
     mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
   fi
else
   printf "\n\t  Error: Check Your \$LFS Variable \n"
fi
