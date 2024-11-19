# Chapter 9

<p> General Network Configuration
```
cat > /etc/systemd/network/10-ethernet-dhcp.network << "EOF"
[Match]
Name=enp*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF
```
<br>Setting Hostname
`echo "<lfs>" > /etc/hostname`

<br>Customizing the /etc/hosts File
```
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

<192.168.0.2> <FQDN> [alias1] [alias2] ...
::1       ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF
```
</p>

## Installs Before Kernel Install
<p> Install the WGET / CURL / RSYNC as some packages are required for GRUB FOR UEFI<br>
    The GRUB FOR UEFI Installs everything necessary to setup for UEFI Boot from the chroot environment <br>
    as long as the system has been booted with UEFI and the /sys/efivars are available to mount.


