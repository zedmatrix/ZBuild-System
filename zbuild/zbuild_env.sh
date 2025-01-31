#!/bin/bash
# begin /etc/profile.d/zbuild_env.sh

zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zznormal="${zznormal:-\033[0m}"

ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

Src_Extract() {
    zprint "Extracting: ${archive}"
    mkdir -v "${ZBUILD_root}/${packagedir}"
    tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}

zprint() { printf "${zzyellow} *** %s *** ${zznormal} \n" "$*"; }

CurlPaste() {
        file=${1}
        if [ -f ${file} ]; then
                cat "${file}" | curl -F'file=@-' https://0x0.st
        else
                print "Warning: File Needs to Exist"
        fi
}

Source_wget() {
        if [ -z $1 ]; then
                echo "Atleast one argument is needed"
        else
                wget $1 --no-clobber --rejected-log=${ZBUILD_log}/wget_rejects.log -P ${ZBUILD_sources}
        fi
}

export zzred zzgreen zzyellow zznormal
export ZBUILD_root ZBUILD_sources ZBUILD_script ZBUILD_log
export -f zprint Source_wget Curl_Paste


# end /etc/profile.d/zbuild_env.sh
