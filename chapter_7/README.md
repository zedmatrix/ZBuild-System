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
