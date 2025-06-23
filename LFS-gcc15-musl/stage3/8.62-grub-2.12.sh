#!/bin/bash
SOURCES=${SOURCES:-/sources}
DEPENDS=('gettext bash xz help2man python texinfo')

#https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz

export PACKAGE=grub-2.12
tar xf $SOURCES/grub-2.12.tar.xz && pushd $PACKAGE

unset {C,CPP,CXX,LD}FLAGS
echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr --sysconfdir=/etc --disable-efiemu --disable-werror

make

## Testsuite is not recommended in the limited LFS Environment
# make check

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

popd
rm -rf $PACKAGE
