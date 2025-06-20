#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Util-Linux-2.41

tar xf $SOURCES/util-linux-2.41.tar.xz && pushd util-linux-2.41

mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib --runstatedir=/run --disable-chfn-chsh --disable-login --disable-nologin \
  --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --disable-liblastlog2 \
  --without-python ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.41

make
make install

popd

rm -rf util-linux-2.41
