#       Linux-6.11.9

Building the kernel involves a few steps—configuration, compilation, and installation.<br>
Read the README file in the kernel source tree for alternative methods to the way this book configures the kernel.<br>

##   Preparing the Build Process in a nutshell

```
make mrproper
make menuconfig
make
make modules_install
```

### Installing the Kernel

  if separate /boot partition `mount /boot` else just copy the files to the /boot directory.
  
```    
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.11.9-lfs-r12.2-19-systemd
cp -iv System.map /boot/System.map-6.11.9
cp -iv .config /boot/config-6.11.9
cp -r Documentation -T /usr/share/doc/linux-6.11.9
```

### Configuring Linux Module Load Order

Most of the time Linux modules are loaded automatically, but sometimes it needs some specific direction.<br>
The program that loads modules, modprobe or insmod, uses /etc/modprobe.d/usb.conf for this purpose.<br>
This file needs to be created so that if the USB drivers (ehci_hcd, ohci_hcd and uhci_hcd) have been built as modules,<br>
they will be loaded in the correct order; ehci_hcd needs to be loaded prior to ohci_hcd and uhci_hcd in order to avoid a warning being output at boot time.

Create a new file /etc/modprobe.d/usb.conf by running the following:
```
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
```
