zprint "Cloning Firmware"
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

echo '>>> ./copy-firmware.sh /usr/lib/firmware'

head -n7 /proc/cpuinfo

zprint "Download that script and run it against the bin file to check which processors have updates."
wget https://github.com/AMDESE/amd_ucode_info/blob/master/amd_ucode_info.py
wget https://anduin.linuxfromscratch.org/BLFS/linux-firmware/amd-ucode/microcode_amd_fam16h.bin
wget https://ftp.gnu.org/gnu/cpio/cpio-2.15.tar.bz2 -P $ZBUILD_sources
