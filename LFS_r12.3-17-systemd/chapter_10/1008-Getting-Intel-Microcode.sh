printf "\n\t Intel Microcode for the CPU \n Navigate to \n"
printf "\n https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/ \n"

srcurl="https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/archive/refs/tags"
archive="microcode-20250211.tar.gz"

which wget || exit

wget -P /sources $srcurl/$archive

