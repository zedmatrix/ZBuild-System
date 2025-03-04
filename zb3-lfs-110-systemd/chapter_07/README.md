# <p align="center"> Chapter 7 Entering Chroot and Building Additional Temporary Tools </p>
<br>
At this point we are done with the {lfs} user which we can exit from the shell.<br>

## 7.2 Changing Ownership
Currently, the whole directory hierarchy in $LFS is owned by the user lfs, a user that exists only on the host system. If the directories and files under $LFS are kept as they are, they will be owned by a user ID without a corresponding account. This is dangerous because a user account created later could get this same user ID and would own all the files under $LFS, thus exposing these files to possible malicious manipulation.<br>

## 7.3 Preparing Virtual Kernel File Systems
Applications running in userspace utilize various file systems created by the kernel to communicate with the kernel itself. These file systems are virtual: no disk space is used for them. The content of these file systems resides in memory. These file systems must be mounted in the $LFS directory tree so the applications can find them in the chroot environment.<br>

## 7.4 Entering the Chroot Environment
Now that all the packages which are required to build the rest of the needed tools are on the system, it is time to enter the chroot environment and finish installing the temporary tools. This environment will also be used to install the final system. As user root, run the following command to enter the environment that is, at the moment, populated with nothing but temporary tools:<br>

## 7.5 Creating Directories

## 7.6 Creating Essential Files and Symlinks

## 7.13.2. Backup

At this point the essential programs and libraries have been created and your current LFS system is in a good state. Your system can now be backed up for later reuse. In case of fatal failures in the subsequent chapters, it often turns out that removing everything and starting over (more carefully) is the best way to recover. Unfortunately, all the temporary files will be removed, too. To avoid spending extra time to redo something which has been done successfully, creating a backup of the current LFS system may prove useful. 

```exit``` 

Before making a backup, unmount the virtual file systems:
```
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
```
Make sure you have at least 1 GB free disk space (the source tarballs will be included in the backup archive) on the file system containing the directory where you create the backup archive.
```
cd $LFS
tar -cJpf $HOME/lfs-temp-tools-r12.2-15-systemd.tar.xz .
```

## 7.13.3. Restore

In case some mistakes have been made and you need to start over, you can use this backup to restore the system and save some recovery time. Since the sources are located under $LFS, they are included in the backup archive as well, so they do not need to be downloaded again. After checking that $LFS is set properly, you can restore the backup by executing the following commands:

```
cd $LFS
rm -rf ./*
tar -xpf $HOME/lfs-temp-tools-r12.2-15-systemd.tar.xz
```

<br> Note the $HOME is where the archive is located and where you want to save it <br>
