#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('bzip2 expat gdbm libffi libxcrypt openssl zlib tcl xz')

#https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tar.xz

export PACKAGE=Python-3.13.5
tar xf $SOURCES/Python-3.13.5.tar.xz && pushd $PACKAGE

./configure --prefix=/usr --enable-shared --with-system-expat \
  --enable-optimizations --without-static-libpython --disable-test-modules

# Result: FAILURE
## test_re failed (2 failures)
## to skip internal test
make PROFILE_TASK="-m test --pgo --ignore 'test.test_re.ReTests.test_locale_caching' --ignore 'test.test_re.ReTests.test_locale_compiled'"

## Checked 112 modules (33 built-in, 61 shared, 1 n/a on linux-x86_64, 16 disabled, 1 missing, 0 failed on import)
## make[1]: Leaving directory '/zbuild/Python-3.13.5'

make test TESTOPTS="--timeout 120"
# # 2 tests skipped (resource denied):
# #     test_peg_generator test_zipfile64
# # 12 re-run tests:
# #     test.test_inspect.test_inspect test__locale test_c_locale_coercion
# #     test_class test_compile test_ctypes test_locale test_os test_posix
# #     test_re test_socket test_strptime
# # 11 tests failed:
# #     test.test_inspect.test_inspect test__locale test_c_locale_coercion
# #     test_class test_compile test_ctypes test_locale test_os test_posix
# #     test_re test_strptime
# #
# # 414 tests OK.
# # Total duration: 5 min 1 sec
# # Total tests: run=39,936 failures=246 skipped=2,343
# # Total test files: run=490/480 failed=11 skipped=53 resource_denied=2 rerun=12

make install

## update the pip conf
cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

## Optional Install Documentation
#https://www.python.org/ftp/python/doc/3.13.5/python-3.13.5-docs-html.tar.bz2
# install -v -dm755 /usr/share/doc/python-3.13.5/html
#
# tar --strip-components=1 --no-same-owner --no-same-permissions \
#     -C /usr/share/doc/python-3.13.5/html \
#     -xvf $SOURCES/python-3.13.5-docs-html.tar.bz2

popd

rm -rf $PACKAGE
