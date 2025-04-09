printf "\n\t Creating Intel microcode \n"

codepath="intel-ucode"
microcode=06-45-01

mkdir -pv initrd/kernel/x86/microcode
cd initrd

cp -v ../$codepath/$microcode kernel/x86/microcode/GenuineIntel.bin || exit 1

find . | cpio -o -H newc > /boot/microcode.img

printf "\n\t Appending to /boot/grub/grub.cfg \n"
echo "initrd /boot/microcode.img" >> /boot/grub/grub.cfg
