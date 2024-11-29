zprint "Creating grub.cfg - **DID YOU EDITME**"
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,3)

menuentry "GNU/Linux, Linux 6.11.9-lfs-r12.2-19-systemd" {
    linux   /boot/vmlinuz-6.11.9 root=/dev/sda3 ro
}
EOF
zprint "Done - **DID YOU EDITME**"
