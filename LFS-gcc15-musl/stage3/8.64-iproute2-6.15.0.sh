#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl libcap libelf python')

#https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.15.0.tar.xz

export PACKAGE=iproute2-6.15.0
tar xf $SOURCES/iproute2-6.15.0.tar.xz && pushd $PACKAGE

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns

make SBINDIR=/usr/sbin install

install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.15.0

popd
rm -rf $PACKAGE
