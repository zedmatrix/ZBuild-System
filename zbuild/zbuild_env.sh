#!/bin/bash
unset pkg pkgver package packagedir delete patch
unset prefix build sysconfdir localstatedir runstatedir disable enable

# begin /etc/profile.d/zbuild_env.sh
RED="${RED:-\033[1;31m}"
GREEN="${GREEN:-\033[1;32m}"
YELLOW="${YELLOW:-\033[1;33m}"
NORMAL="${NORMAL:-\033[0m}"

ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

Src_Extract() {
    zprint "Extracting: ${archive}"
    mkdir -v "${ZBUILD_root}/${packagedir}"
    tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}

zprint() { printf "${YELLOW} *** %s *** ${NORMAL} \n" "$*"; }

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

export RED GREEN YELLOW NORMAL
export ZBUILD_root ZBUILD_sources ZBUILD_script ZBUILD_log
export -f Src_Extract zprint Source_wget

# end /etc/profile.d/zbuild_env.sh
