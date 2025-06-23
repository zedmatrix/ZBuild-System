#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('coreutils file glibc|musl libcap ncurses readline shadow zlib')

#https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.xz

export PACKAGE=util-linux-2.41
tar xf $SOURCES/util-linux-2.41.tar.xz && pushd $PACKAGE

./configure --bindir=/usr/bin --libdir=/usr/lib --runstatedir=/run --sbindir=/usr/sbin \
  --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv \
  --disable-runuser --disable-pylibmount --disable-liblastlog2 --disable-static \
  --without-python --without-systemd --without-systemdsystemunitdir \
  ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.41

make

touch /etc/fstab && chown -R tester .
su tester -c "make -k check"
# ---------------------------------------------------------------------
#   2 tests of 336 FAILED
#
#       kill/decode
#       misc/enosys
echo -e "---------------------------------------------------------------------"

make install

popd

rm -rf $PACKAGE
