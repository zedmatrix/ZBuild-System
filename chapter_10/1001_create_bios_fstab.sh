zprint " Creating /etc/fstab - **EDITME** "
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/*sda3     /            ext4     defaults            1     1
/dev/*sda2     swap         swap     pri=1               0     0

# End /etc/fstab
EOF
