#!/bin/bash
# begin /etc/profile.d/zbuild.sh
unset pkg pkgver package packagedir delete patch
unset prefix build sysconfdir statedir disable enable

RED="${RED:-\033[1;31m}"
GREEN="${GREEN:-\033[1;32m}"
YELLOW="${YELLOW:-\033[1;33m}"
NORMAL="${NORMAL:-\033[0m}"

ZBUILD_root="/BUILD"
ZBUILD_sources="/opt/source"
ZBUILD_log="${ZBUILD_root}/Zbuild_Log"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

PackageCheck() {
    pkg=${1}
    [ -z $pkg ] && { echo "Usage: PackageCheck 'Package Name' "; exit 1; }

    printf "Checking For... (%s)" "${pkg}"

    if $(pkg-config --exists "$pkg"); then
        ver=$(pkg-config --modversion "${pkg}")
        printf "... True (%s)\n" "${ver}"
    else
        printf "... False\n"
    fi
}
Src_Extract() {
    print "Extracting: ${archive}"
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
export -f PackageCheck Src_Extract zprint Source_wget

# end /etc/profile.d/zbuild.sh
