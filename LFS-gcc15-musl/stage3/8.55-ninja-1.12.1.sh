#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('gcc-libs python')
#https://github.com/ninja-build/ninja/archive/v1.12.1/ninja-1.12.1.tar.gz

export PACKAGE=ninja-1.12.1
tar xf $SOURCES/ninja-1.12.1.tar.gz && pushd $PACKAGE

export NINJAJOBS=4 &&
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

python3 configure.py --bootstrap --verbose

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

popd
rm -rf $PACKAGE

### ===========================================
DEPENDS=('bash ninja python')

#https://github.com/mesonbuild/meson/releases/download/1.8.2/meson-1.8.2.tar.gz
export PACKAGE=meson-1.8.2
tar xf $SOURCES/meson-1.8.2.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

popd
rm -rf $PACKAGE
