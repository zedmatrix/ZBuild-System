#!/bin/bash
pkgsrc=/sources
pkgdest=/usr/share
#
#	Git Man Pages
#
pkgurl="https://www.kernel.org/pub/software/scm/git/git-manpages-2.49.0.tar.xz"
archive=$(basename $pkgurl)
pkgname=${archive%%.tar*}
pkgver=${pkgname#*-}

printf "\n Installing $pkgname to $pkgdest/man "

[ ! -f $pkgsrc/$archive ] && { echo "Cant Find $pkgsrc/$archive Exiting."; exit 1; }
tar -xf $pkgsrc/$archive -C $pkgdest/man --no-same-owner --no-overwrite-dir
#
#	Git Documentation
#
pkgurl="https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.49.0.tar.xz"
archive=$(basename $pkgurl)
pkgname=${archive%%.tar*}
pkgver=${pkgname#*-}
pkgname=git-$pkgver

printf "\n\t Installing $archive to $pkgdest/doc/$pkgname "
mkdir -pv $pkgdest/doc/$pkgname

[ ! -f $pkgsrc/$archive ] && { echo "Cant Find $pkgsrc/$archive Exiting."; exit 1; }
tar -xf $pkgsrc/$archive -C $pkgdest/doc/$pkgname --no-same-owner --no-overwrite-dir
#
#	Git Re-Organize
#
printf "\n\t Reorganize text and html in the html-docs (both methods) \n"
find $pkgdest/doc/$pkgname -type d -exec chmod 755 {} \; && echo " Completed "
find $pkgdest/doc/$pkgname -type f -exec chmod 644 {} \; && echo " Completed "

mkdir -vp $pkgdest/doc/$pkgname/man-pages/{html,text}
mv $pkgdest/doc/$pkgname/{git*.adoc,man-pages/text}
mv $pkgdest/doc/$pkgname/{git*.,index.,man-pages/}html

mkdir -vp $pkgdest/doc/$pkgname/technical/{html,text}
mv $pkgdest/doc/$pkgname/technical/{*.adoc,text}
mv $pkgdest/doc/$pkgname/technical/{*.,}html

mkdir -vp $pkgdest/doc/$pkgname/howto/{html,text}
mv $pkgdest/doc/$pkgname/howto/{*.adoc,text}
mv $pkgdest/doc/$pkgname/howto/{*.,}html

sed -i '/^<a href=/s|howto/|&html/|' $pkgdest/doc/$pkgname/howto-index.html
sed -i '/^\* link:/s|howto/|&html/|' $pkgdest/doc/$pkgname/howto-index.adoc
