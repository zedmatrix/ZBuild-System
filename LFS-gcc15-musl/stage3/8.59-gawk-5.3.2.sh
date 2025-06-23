#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl mpfr bash')

#https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz

export PACKAGE=gawk-5.3.2
tar xf $SOURCES/gawk-5.3.2.tar.xz && pushd $PACKAGE

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

rm -vf /usr/bin/gawk-5.3.2
make install
ln -sv gawk.1 /usr/share/man/man1/awk.1

## Optional Documenation
# install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2

popd
rm -rf $PACKAGE
