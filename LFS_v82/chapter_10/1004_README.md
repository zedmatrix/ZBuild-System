# Chapter 10.4 - Grub Setup BIOS/UEFI

## BIOS Version

If the system has been booted using UEFI, grub-install will try to install files for the x86_64-efi target,
but those files have not been installed in Chapter 8. If this is the case, add `--target i386-pc` to the command.
<br>
Install the GRUB files into /boot/grub and set up the boot track: `grub-install /dev/sda`

<p>From GRUB's perspective, the kernel files are relative to the partition used. If you used a separate /boot partition, remove `/boot` from the above linux line. You will also need to change the `set root` line to point to the boot partition.</p>

<br>Create the `/boot/grub/grub.cfg` for the partition `/dev/sda3` GRUB Configuration file:

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
        
<p>GRUB is an extremely powerful program and it provides a tremendous number of options for booting from a wide variety of devices, operating systems, and partition types. There are also many options for customization such as graphical splash screens, playing sounds, mouse input, etc. The details of these options are beyond the scope of this introduction.</p>

## UEFI Version

Now create the mount point for the ESP, and mount it (replace sda1 with the device node corresponding to the ESP):

    mount --mkdir -v -t vfat /dev/sda1 -o codepage=437,iocharset=iso8859-1 /boot/efi

    cat >> /etc/fstab << EOF
        /dev/sda1 /boot/efi vfat codepage=437,iocharset=iso8859-1 0 1
    EOF
    
To install GRUB with the EFI application in the hardcoded path `EFI/BOOT/BOOTX64.EFI`, first ensure the boot partition is mounted at `/boot` and the ESP is mounted at `/boot/efi`. Then, as the root user, run the command:

    grub-install --target=x86_64-efi --removable
    
The installation of GRUB on a UEFI platform requires that the EFI Variable file system, efivarfs, is mounted. As the root user, mount it if it's not already mounted: 

    mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
    grub-install --bootloader-id=LFS --recheck
    
Issue the `efibootmgr | cut -f 1` command to recheck the EFI boot configuration. An example of the output is:

    BootCurrent: 0000
    Timeout: 1 seconds
    BootOrder: 0005,0000,0002,0001,0003,0004
    Boot0000* ARCH
    Boot0001* UEFI:CD/DVD Drive
    Boot0002* Windows Boot Manager
    Boot0003* UEFI:Removable Device
    Boot0004* UEFI:Network Device
    Boot0005* LFS
    
 Creating the GRUB Configuration File

Generate `/boot/grub/grub.cfg` for the root partition `/dev/sda3` to configure the boot menu of GRUB:

    cat > /boot/grub/grub.cfg << EOF
    # Begin /boot/grub/grub.cfg
    set default=0
    set timeout=5

    insmod part_gpt
    insmod ext2
    set root=(hd0,3)

    insmod efi_gop
    insmod efi_uga
    if loadfont /boot/grub/fonts/unicode.pf2; then
        terminal_output gfxterm
    fi

    menuentry "GNU/Linux, Linux 6.11.9-lfs-12.2-19-systemd" {
        linux   /boot/vmlinuz-6.11.9 root=/dev/sda3 ro
    }

    menuentry "Firmware Setup" {
        fwsetup
    }
    EOF
    
<p>The insmod efi_gop and insmod efi_uga directives load two modules for EFI-based video support. On most systems the efi_gop module is enough. The efi_uga module is only useful for legacy systems, but it's harmless to load it anyway. The video support is needed for the terminal_output gfxterm directive to really work.</p>

<p>The terminal_output gfxterm directive changes the display resolution of the GRUB menu to match your display device. It will break the rendering if the unicode.pf2 font data file is not loaded, so it's guarded by a if directive. </p>

