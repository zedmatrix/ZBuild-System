#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}
DEPENDS=('libtasn1')

#https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz

export PACKAGE=p11-kit-0.25.5
tar xf $SOURCES/p11-kit-0.25.5.tar.xz && pushd $PACKAGE

sed '20,$ d' -i trust/trust-extract-compat

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

meson setup p11-build  --prefix=/usr --buildtype=release \
      -D trust_paths=/etc/pki/anchors

meson compile -C p11-build

LC_ALL=C meson test -C p11-build
# Ok:                67
# Fail:              0

meson install -C p11-build

ln -sfv /usr/libexec/p11-kit/trust-extract-compat /usr/bin/update-ca-certificates

popd
rm -rf $PACKAGE
