#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('file glibc|musl ncurses')
#https://www.nano-editor.org/dist/v8/nano-8.5.tar.xz

export PACKAGE=nano-8.5
tar xf $SOURCES/nano-8.5.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --sysconfdir=/etc --enable-utf8 \
            --docdir=/usr/share/doc/nano-8.5

make

# No real testsuite available
#make check

make install
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-8.5

cat > /etc/nanorc << "EOF"
set autoindent
# set boldtext
set constantshow
set fill 72
set historylog
set indicator
set multibuffer
set positionlog
set quickblank
set regexp
# set softwrap
set tabsize 4

include /usr/share/nano/sh.nanorc
EOF

popd

rm -rf $PACKAGE
