#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gzip ncurses perl bash')

#https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz

export PACKAGE=texinfo-7.2
bsdtar xf $SOURCES/texinfo-7.2.tar.xz && pushd $PACKAGE

./configure --prefix=/usr

make

make check
## Testsuite summary for GNU Texinfo 7.2
# TOTAL: 125
# PASS:  81
# SKIP:  40
# XFAIL: 0
# FAIL:  4
# XPASS: 0
# ERROR: 0
## ============================================================================
# FAIL: test_scripts/layout_formatting_fr_icons.sh
# FAIL: test_scripts/layout_formatting_fr.sh
# FAIL: test_scripts/layout_formatting_fr_info.sh
# FAIL: test_scripts/formatting_documentlanguage_cmdline.sh

echo -e "============================================================================"
make install

#Optionally, install the components belonging in a TeX installation:
# make TEXMF=/usr/share/texmf install-tex

# The Info documentation system uses a plain text file to hold its list of menu entries.

# The file is located at /usr/share/info/dir.
# Due to occasional problems in the Makefiles of various packages can get out of sync.
# If the /usr/share/info/dir file ever needs to be recreated issue optional commands:

pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd


popd

rm -rf $PACKAGE
