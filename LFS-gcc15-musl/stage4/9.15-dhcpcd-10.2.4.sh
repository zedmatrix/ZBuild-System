#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/NetworkConfiguration/dhcpcd/releases/download/v10.2.4/dhcpcd-10.2.4.tar.xz

export PACKAGE=dhcpcd-10.2.4
tar xf $SOURCES/dhcpcd-10.2.4.tar.xz && pushd $PACKAGE

install  -v -m700 -d /var/lib/dhcpcd

groupadd -g 52 dhcpcd
useradd  -c 'dhcpcd PrivSep' -d /var/lib/dhcpcd -g dhcpcd \
         -s /bin/false -u 52 dhcpcd

chown -v dhcpcd:dhcpcd /var/lib/dhcpcd

./configure --prefix=/usr --sysconfdir=/etc --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd --runstatedir=/run --privsepuser=dhcpcd

make

make test

make install

popd
rm -rf $PACKAGE
