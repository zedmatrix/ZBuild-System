#!/bin/bash
# begin /etc/profile.d/zbuild_env.sh

zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzcyan="${zzcyan:-\033[1;36m}"
zzyellow="${zzyellow:-\033[1;33m}"
zznormal="${zznormal:-\033[0m}"

ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild3.sh"

ZBUILD_Extract() {
    zprint "Extracting: ${archive} to ${packagedir}"
    mkdir -v "${ZBUILD_root}/${packagedir}"
    tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}

SourceGet() {
if [ -z $1 ]; then
		 echo "Atleast one argument is needed"
	else
		wget "$1" --continue --no-clobber -P ${ZBUILD_sources}
	fi
}

zzprint() { printf "${zzyellow} *** %s *** ${zznormal} \n" "$*"; }
zprint() { printf "${zzcyan} *** %s *** ${zznormal}\n" "$*"; }

export zzred zzcyan zzgreen zzyellow zznormal
export ZBUILD_root ZBUILD_sources ZBUILD_script ZBUILD_log
export -f SourceGet zprint zzprint ZBUILD_Extract

# end /etc/profile.d/zbuild_env.sh
