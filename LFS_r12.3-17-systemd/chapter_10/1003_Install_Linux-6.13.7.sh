#!/bin/bash
pkgsrc=/sources
pkgdest=/usr/src
pkgurl="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.13.7.tar.xz"

archive=$(basename $pkgurl)
pkgname=${archive%%.tar*}
pkgver=${pkgname#*-}

printf "\n\t Installing Linux $pkgver Kernel\n"

printf "\t Installing $pkgname to /boot \n"

if [[ -d $pkgdest/$pkgname ]]; then
	pushd $pkgdest/$pkgname
		make modules_install
		cp -iv arch/x86/boot/bzImage /boot/vmlinuz-$pkgver
	    cp -iv System.map /boot/System.map-$pkgver
	    cp -iv .config /boot/config-$pkgver
	popd
else
	echo " Failure "
fi

printf "\n\t *** Done *** \n"
