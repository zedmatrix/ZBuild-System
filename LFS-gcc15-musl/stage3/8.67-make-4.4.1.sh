#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl')

#https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz

export PACKAGE=make-4.4.1
tar xf $SOURCES/make-4.4.1.tar.gz && pushd $PACKAGE

patch -Np1 -i $SOURCES/make-4.4.1-gcc15.patch

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"
## 1427 Tests in 133 Categories Complete ... No Failures :-)

make install

popd
rm -rf $PACKAGE
