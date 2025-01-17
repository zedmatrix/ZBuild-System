# Building Linux From Scatch 
## Using Zbuild v2.0
<p>
  Using a previous version of LFS or the Gentoo Live CD and the mount instructions from the main README.md
  You can reproduce the LFS system. 
</p>

Adding `zbuild_env.sh` to your `/etc/profile.d` directory or `. zbuild_env.sh` will allow the <br>
`zbuild2.sh` script the functions and definitions needed... as well as adjusting them for the initial<br>
LFS chapters 5 to 7 environment.

## Testing
I have tested all of the scripts and go through updating them to the latest Linux From Scratch Development Release.<br>

Quick unmount single line
`umount -v /mnt/lfs{/dev{/shm,/pts,},/run,/sys,/proc,}`
