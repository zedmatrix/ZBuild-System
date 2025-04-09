#!/bin/bash
if [ -d $LFS ] && [ -n $LFS ]; then
    echo "*** Creating Directories for $LFS "
    mkdir -pv $LFS/{etc,var,tools} $LFS/usr/{bin,lib,sbin}

    echo "*** Creating Symlinks for bin,sbin,lib"
    for i in bin lib sbin; do
        ln -sv usr/$i $LFS/$i
    done


    case $(uname -m) in
        x86_64)
            echo "*** Creating lib64 directory"
            mkdir -pv $LFS/lib64
        ;;
    esac

else
    echo "*** Error: {LFS} is not set"
fi
