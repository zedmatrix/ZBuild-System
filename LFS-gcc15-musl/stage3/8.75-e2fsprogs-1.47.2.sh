#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('bash util-linux')

#https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.2/e2fsprogs-1.47.2.tar.gz

export PACKAGE=e2fsprogs-1.47.2
tar xf $SOURCES/e2fsprogs-1.47.2.tar.gz && pushd $PACKAGE

mkdir -v build && cd build

../configure --prefix=/usr --sysconfdir=/etc --enable-elf-shlibs \
  --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck

make

make check
# 393 tests succeeded     1 tests failed
# Tests failed: m_assume_storage_prezeroed

make install

## Optional to remove static libraries
# rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

##If desired, create and install some additional documentation:
# makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
# install -v -m644 doc/com_err.info /usr/share/info
# install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info


popd

rm -rf $PACKAGE
