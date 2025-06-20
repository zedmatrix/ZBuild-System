#!/bin/bash
export SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Musl - 1.2.5 - Final

export PACKAGE=musl-1.2.5
tar xf $SOURCES/$PACKAGE.tar.gz && pushd $PACKAGE

patch -Np1 -i $SOURCES/musl-1.2.5-rpmalloc.patch
patch -Np1 -i $SOURCES/musl-1.2.5-iconv-fix.patch

./configure --prefix=/usr --with-malloc=rpmalloc

make

make install

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

cat > /etc/ld-musl-x86_64.path << "EOF"
# Begin /etc/ld.so.conf
/usr/lib
/usr/local/lib
/opt/lib

EOF

case $(uname -m) in
    i?86) ln -sfv ../lib/ld-musl.so.1 /usr/bin/ldd
    ;;
    x86_64) ln -sfv ../lib/ld-musl-x86_64.so.1 /usr/bin/ldd
    ;;
esac

popd

rm -rf $PACKAGE
