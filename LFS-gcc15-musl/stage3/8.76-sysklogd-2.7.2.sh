#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

#https://github.com/troglobit/sysklogd/releases/download/v2.7.2/sysklogd-2.7.2.tar.gz

export PACKAGE=sysklogd-2.7.2
tar xf $SOURCES/sysklogd-2.7.2.tar.gz && pushd $PACKAGE

./configure --prefix=/usr --sysconfdir=/etc --runstatedir=/run \
  --without-logger --disable-static --docdir=/usr/share/doc/sysklogd-2.7.2

make

make install

## Configuration
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# Do not open any internet ports.
secure_mode 2

# End /etc/syslog.conf
EOF

popd

rm -rf $PACKAGE
