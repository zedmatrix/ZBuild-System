#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('python')
### ==============================================
## Python Modules

# https://pypi.org/packages/source/f/flit-core/flit_core-3.12.0.tar.gz
export PACKAGE=flit_core-3.12.0
tar xf $SOURCES/flit_core-3.12.0.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist flit_core

popd
rm -rf $PACKAGE

### ==============================================
# https://files.pythonhosted.org/packages/source/p/packaging/packaging-25.0.tar.gz

export PACKAGE=packaging-25.0
tar xf $SOURCES/packaging-25.0.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist packaging

popd
rm -rf $PACKAGE

### ==============================================
#https://pypi.org/packages/source/w/wheel/wheel-0.46.1.tar.gz
export PACKAGE=wheel-0.46.1
tar xf $SOURCES/wheel-0.46.1.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist wheel

popd
rm -rf $PACKAGE

### ==============================================
#https://pypi.org/packages/source/s/setuptools/setuptools-80.9.0.tar.gz
export PACKAGE=setuptools-80.9.0
tar xf $SOURCES/setuptools-80.9.0.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist setuptools

popd
rm -rf $PACKAGE

