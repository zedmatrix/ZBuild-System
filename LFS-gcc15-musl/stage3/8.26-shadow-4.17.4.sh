#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('acl attr glibc|musl libxcrypt libcap')

#https://github.com/shadow-maint/shadow/releases/download/4.17.4/shadow-4.17.4.tar.xz

export PACKAGE=shadow-4.17.4
tar xf $SOURCES/shadow-4.17.4.tar.xz && pushd $PACKAGE

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:' -e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
    -i etc/login.defs

touch /usr/bin/passwd

./configure --sysconfdir=/etc --disable-static --with-{b,yes}crypt \
  --without-libbsd --with-group-name-max-length=32

make

make exec_prefix=/usr install
make -C man install-man

# Configuring Shadow
pwconv
grpconv
mkdir -p /etc/default
useradd -D --gid 999

# Set Root Password : lfsroot :
passwd root

# Clean Up
popd

rm -rf $PACKAGE
