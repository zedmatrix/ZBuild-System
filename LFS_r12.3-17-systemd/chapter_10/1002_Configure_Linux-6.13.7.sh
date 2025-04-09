printf "\n\t Configuring Linux-6.13.7 \n"
pkgsrc=/sources
pkgdest=/usr/src

pkgurl="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.13.7.tar.xz"

archive=$(basename $pkgurl)
pkgname=${archive%%.tar*}

printf "\t decompressing $pkgname to $pkgsrc \n"
[ ! -f $pkgsrc/$archive ] && { echo " Missing $archive - exiting."; exit 1; }
[ ! -d $pkgdest ] && mkdir -pv $pkgdest

tar xf $pkgsrc/$archive -C $pkgdest
echo "Return Code: $?"

if [[ -d $pkgdest/$pkgname ]]; then
	echo " Success "
	cp -v 1001_config_zb3 $pkgdest/$pkgname/.config || { echo "Copy Failure. Exiting"; exit 1; }
	pushd $pkgdest/$pkgname
		make mrproper
		make olddefconfig
		make
	popd
else
	echo " Failure "
fi

printf "\n\t *** Done *** \n"
