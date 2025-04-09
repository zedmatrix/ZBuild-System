#!/bin/bash

pkgname=python-3.13.2
pkgurl="https://www.python.org/ftp/python/doc/3.13.2/python-3.13.2-docs-html.tar.bz2"
pkgarc=$(basename $pkgurl)

printf "\n\t Installing $pkgname Documentation and Configuring pip \n"

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
[ -f /etc/pip.conf ] && echo " Created: /etc/pip.conf "


if [[ -f /sources/$pkgarc ]]; then
	install -v -dm755 /usr/share/doc/$pkgname/html

	tar --strip-components=1 --no-same-owner --no-same-permissions -C /usr/share/doc/$pkgname/html \
    -xvf /sources/$pkgarc
else
	printf "\n\t Error: $pkgarc Not Found in /sources \n "
	printf "\t Download Source: $pkgurl \n "
fi

printf "\n\t Done \n"
