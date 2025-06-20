#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# Gettext - 0.25

tar xf $SOURCES/gettext-0.25.tar.xz && pushd gettext-0.25

./configure --disable-shared

make

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

popd

rm -rf gettext-0.25
