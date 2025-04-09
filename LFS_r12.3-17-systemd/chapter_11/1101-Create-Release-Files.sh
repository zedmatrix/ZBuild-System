#!/bin/bash
name="Zedmatrix"
version="r12.3-17-systemd"
printf "\n\t *** Creating System Release Files *** \n"

echo ${version} > /etc/lfs-release
[ -f /etc/lfs-release ] && echo " Created: /etc/lfs-release "

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="${version}"
DISTRIB_CODENAME="${name}"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
[ -f /etc/lsb-release ] && echo " Created: /etc/lsb-release "

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="${version}"
ID=lfs
PRETTY_NAME="Linux From Scratch - ${version}"
VERSION_CODENAME="${name}"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
EOF
[ -f /etc/os-release ] && echo " Created: /etc/os-release "

printf "\n\n \t *** The End *** \n\n"
