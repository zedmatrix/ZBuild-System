#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.93.tar.xz

export PACKAGE=linux-6.6.93
tar xf $SOURCES/linux-6.6.93.tar.xz && pushd $PACKAGE

# Prepare Source
make mrproper

# Configuring
zcat /proc/config.gz > .config

make listnewconfig

make olddefconfig

make menuconfig

# Building / Compiling
make
make modules_install

# Installing
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.6.93
cp -iv System.map /boot/System.map-6.6.93
cp -iv .config /boot/config-6.6.93

# Optional Documentation Install
# cp -r Documentation -T /usr/share/doc/linux-6.6.93

popd

rm -rf $PACKAGE

#  Configuring Linux Module Load Order
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
