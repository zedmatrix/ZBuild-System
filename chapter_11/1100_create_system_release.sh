zprint "Creating System Release Files"

echo r12.2-19-systemd > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="r12.2-19-systemd"
DISTRIB_CODENAME="zedmatrix"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="r12.2-19-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch r12.2-19-systemd"
VERSION_CODENAME="zedmatrix"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
EOF

zprint "Done"
