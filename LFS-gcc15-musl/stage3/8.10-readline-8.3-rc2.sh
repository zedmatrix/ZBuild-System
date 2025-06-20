#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://ftp.gnu.org/gnu/readline/readline-8.3-rc2.tar.gz

export PACKAGE=readline-8.3-rc2
tar xf $SOURCES/readline-8.3-rc2.tar.gz && pushd $PACKAGE

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

./configure --prefix=/usr --disable-static --with-curses \
  --docdir=/usr/share/doc/readline-8.3-rc2

make SHLIB_LIBS="-lncursesw"

make install

# Optional
#install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3-rc2

popd

rm -rf $PACKAGE
