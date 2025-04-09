#!/bin/bash
printf "\n\t Creating etc/systemd/network File \n"
cat > /etc/systemd/network/10-ethernet-dhcp.network << "EOF"
[Match]
Name=enp*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF
[ -f "/etc/systemd/network/10-ethernet-dhcp.network" ] && echo "Created: /etc/systemd/network/10-ethernet-dhcp.network "

printf "\n\t Creating /etc/hosts and /etc/hostname \n"
echo "Nitrogen" > /etc/hostname
[ -f /etc/hostname ] && echo "Created: /etc/hostname "

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

# IPv4 and IPv6 localhost aliases
127.0.0.1       localhost
::1       ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF
[ -f /etc/hosts ] && echo "Created: /etc/hosts "

printf "\t Creating Simple /etc/resolv.conf \n"
systemctl enable systemd-networkd
#systemctl enable systemd-resolved
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain localdomain
nameserver 8.8.8.8
nameserver 8.8.4.4

search localdomain

# End /etc/resolv.conf
EOF
[ -f /etc/resolv.conf ] && echo " Created: /etc/resolv.conf "
printf "\n\t Done \n"
