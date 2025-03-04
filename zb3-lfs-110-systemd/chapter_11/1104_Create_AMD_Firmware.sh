zprint "Creating AMD microcode"
mkdir -pv initrd/kernel/x86/microcode
cd initrd

cp -v ../microcode_amd_fam16h.bin kernel/x86/microcode/AuthenticAMD.bin

find . | cpio -o -H newc > /boot/microcode.img

zprint "Append to /boot/grub/grub.cfg"
echo "initrd /boot/microcode.img" >> /boot/grub/grub.cfg
