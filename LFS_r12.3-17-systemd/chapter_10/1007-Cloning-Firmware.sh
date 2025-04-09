#!/bin/bash
printf "\n\t *** Cloning Firmware *** \n"
pushd /usr/src
	git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
popd

printf "\n\t Now Just Change to /usr/src/linux-firmware and \n"
printf "\n$ ./copy-firmware.sh /usr/lib/firmware \n"

head -n7 /proc/cpuinfo | awk '
/cpu family/ { family = $4 }
/model/ && !/name/ { model = $3 }
/stepping/ { stepping = $3 }
END { printf "%02X-%02X-%02X\n", family, model, stepping }'

head -n7 /proc/cpuinfo
