#!/bin/bash
printf "\n\t Configuring Glibc-2.41 \n"
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files systemd
group: files systemd
shadow: files systemd

hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
[ -f /etc/nsswitch.conf ] && echo "Created /etc/nsswitch.conf"

timezonedir=glibc-tzdata
mkdir -v $timezonedir

tar -xf /sources/tzdata2025a.tar.gz -C $timezonedir || { echo "tar failure. exiting."; exit 1; }
pushd $timezonedir

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/Vancouver
unset ZONEINFO

popd
printf " Cleaning Up $timezonedir "
rm -rf $timezonedir

tzselect
ln -sfv /usr/share/zoneinfo/America/Vancouver /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

include /etc/ld.so.conf.d/*.conf

EOF
[ -f /etc/ld.so.conf ] && echo "Created: /etc/ld.so.conf"
mkdir -pv /etc/ld.so.conf.d

