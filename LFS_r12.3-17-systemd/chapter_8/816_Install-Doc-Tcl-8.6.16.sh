#!/bin/bash
ZBUILD_sources=/sources

tcldocurl=https://downloads.sourceforge.net/tcl/tcl8.6.16-html.tar.gz

tcldoc=$(basename $tcldocurl)

printf "\n\t Installing $tcldoc from $ZBUILD_sources \n"

if [[ ! -f $ZBUILD_sources/$tcldoc ]]; then
	printf "\n\t Missing $tcldoc from $ZBUILD_sources \n "

else
	mkdir -pv tcldoc
	pushd tcldoc

	tar xf $ZBUILD_sources/$tcldoc --strip-components=1
	mkdir -v -p /usr/share/doc/tcl-8.6.16
	cp -v -r  ./html/* /usr/share/doc/tcl-8.6.16

	popd
fi

printf "\n\t Done \n"
