#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl libcap libxcrypt ncurses readline python')

#https://ftp.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz

export PACKAGE=inetutils-2.6
tar xf $SOURCES/inetutils-2.6.tar.xz && pushd $PACKAGE

sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr --bindir=/usr/bin --localstatedir=/var \
  --disable-logger --disable-whois --disable-rcp --disable-rexec \
  --disable-rlogin --disable-rsh --disable-servers

make

make check
## Testsuite summary for GNU inetutils 2.6
# TOTAL: 12
# PASS:  11
# SKIP:  1
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0

make install
mv -v /usr/{,s}bin/ifconfig

popd

rm -rf $PACKAGE
