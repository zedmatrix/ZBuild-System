#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl readline ncurses')

#https://ftp.gnu.org/gnu/bash/bash-5.3-rc2.tar.gz

export PACKAGE=bash-5.3-rc2
tar xf $SOURCES/bash-5.3-rc2.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --without-bash-malloc \
  --with-installed-readline --docdir=/usr/share/doc/bash-5.3-rc2

make
## ls -l bash
## -rwxr-xr-x 1 root root 992728 Jun 21 02:23 bash
## size bash
##    text    data     bss     dec     hex filename
##  831738   23796   62920  918454   e03b6 bash

chown -R tester .
su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF

make install

popd

rm -rf $PACKAGE

## exec /usr/bin/bash --login
