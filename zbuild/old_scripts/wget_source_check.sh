#!/bin/bash
bail() { zprint "$*"; exit 1; }
usage() {
	zprint "Usage: $0 [wget.list] [md5.list]"
	bail "Missing WGET list"
}

_wgetfile="${PWD}/${1}"
_md5file="${PWD}/${2}"

[ ! -f "$_wgetfile" ] && usage
[ ! -f "$_md5file" ] && usage

WGETLOG="${ZBUILD_log}/${_wgetfile}.log"
SOURCE="${ZBUILD_sources}"
[ ! -d "$SOURCE" ] && bail "Missing \$SOURCE directory"

while read -r package_url; do

    [[ "$package_url" =~ ^#.*$ || -z "$package_url" ]] && continue

    package="${package_url##*/}"

	if [ ! -f "${SOURCE}/${package}" ]; then
	    zprint "Downloading: $package"
		wget -P "${SOURCE}" "${package_url}"
		echo "${package} ...OK" >> $WGETLOG
	else
		zprint "Skipping: ${package} ...Exists."
		echo "${package} ...SKIP" >> $WGETLOG
	fi

done < <(grep -v '^#' "$_wgetfile")

zprint "All Downloads Completed. "

pushd $SOURCE
	md5sum -c ${_md5file}
popd
zprint "DONE"
