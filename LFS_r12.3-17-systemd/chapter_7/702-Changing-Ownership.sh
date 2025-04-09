#!/bin/bash
if [ -v LFS ] && [ -n "$LFS" ]; then

  printf "\n\t Changing Ownership from lfs to root \n"
  chown --from lfs -vR root:root $LFS/{usr,lib,var,etc,bin,sbin,tools,zbuild}

  case $(uname -m) in
    x86_64) chown --from lfs -vR root:root $LFS/lib64 ;;
  esac

  printf "\n\t Creating Virtual Kernel Directories \n"
  mkdir -pv $LFS/{dev,proc,sys,run}
else
  printf "\n\t Error: Check your \$LFS Variable \n"
fi
