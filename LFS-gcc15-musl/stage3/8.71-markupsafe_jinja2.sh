#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('glibc|musl python')
PYTHON_DEPENDS=('build installer setuptools wheel')

#https://pypi.org/packages/source/M/MarkupSafe/markupsafe-3.0.2.tar.gz

export PACKAGE=markupsafe-3.0.2
bsdtar -xf $SOURCES/markupsafe-3.0.2.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Markupsafe

popd

rm -rf $PACKAGE

echo -e "============================================================================"

PYTHON_DEPENDS=('build installer setuptools wheel flit_core markupsafe')
#https://pypi.org/packages/source/J/Jinja2/jinja2-3.1.6.tar.gz

export PACKAGE=jinja2-3.1.6
bsdtar -xf $SOURCES/jinja2-3.1.6.tar.gz && pushd $PACKAGE

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Jinja2

popd

rm -rf $PACKAGE
