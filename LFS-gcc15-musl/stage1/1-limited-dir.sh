#!/bin/bash

LFS=${LFS:-/mnt/lfs}

mkdir -pv $LFS/{etc,var,tools,sources,zbuild} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
