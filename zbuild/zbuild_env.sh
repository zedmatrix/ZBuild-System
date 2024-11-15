#!/bin/bash
# begin /etc/profile.d/zbuild.sh
unset pkg pkgver package packagedir delete patch
unset prefix build sysconfdir statedir disable enable

RED="\e[1;31m"
GREEN="\e[1;32"
YELLOW="\e[1;33m"
NORMAL="\e[0m"

BUILD_ROOT="/BUILD"
BUILD_SOURCE="/opt/source"
BUILD_LOG="${BUILD_ROOT}/Zbuild_Logs"
BUILD_CMD="${BUILD_ROOT}/zbuild2.sh"

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
    mkdir -v "${BUILD_ROOT}/${packagedir}"
    tar -xf "${BUILD_SOURCE}/${archive}" -C "${BUILD_ROOT}/${packagedir}" --strip-components=1
}

print() { printf "${YELLOW} *** %s *** ${NORMAL} \n" "$*"; }

SRCGET() {
        if [ -z $1 ]; then
                echo "Atleast one argument is needed"
        else
                wget $1 --no-clobber --rejected-log=${BUILD_LOG}/wget_rejects.log -P ${BUILD_SOURCE}
        fi
}

export RED GREEN YELLOW NORMAL
export BUILD_CMD BUILD_LOG BUILD_ROOT BUILD_SOURCE
export -f PackageCheck Src_Extract print SRCGET

# end /etc/profile.d/zbuild.sh
