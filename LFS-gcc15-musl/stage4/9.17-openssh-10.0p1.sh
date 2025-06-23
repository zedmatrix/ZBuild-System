#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.0p1.tar.gz

export PACKAGE=openssh-10.0p1
tar xf $SOURCES/openssh-10.0p1.tar.gz && pushd $PACKAGE

install -v -g sys -m700 -d /var/lib/sshd

groupadd -g 50 sshd
useradd  -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd

./configure --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-path=/var/lib/sshd \
  --with-default-path=/usr/bin --with-superuser-path=/usr/sbin:/usr/bin --with-pid-dir=/run

make

make -j1 tests
##
# 332 tests ok
# test_hostkeys: 18 tests ok
# test_match: 6 tests ok
# test_misc:  43 tests ok
#
# unit tests passed
# all tests passed

##
make install

install -v -m755 contrib/ssh-copy-id /usr/bin
install -v -m644 contrib/ssh-copy-id.1 /usr/share/man/man1
install -v -m755 -d /usr/share/doc/openssh-10.0p1
install -v -m644 INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-10.0p1

## Setup to allow root login
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config

popd
rm -rf $PACKAGE
