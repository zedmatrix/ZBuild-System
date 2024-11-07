#!/bin/bash
# begin /etc/profile.d/zbuild.sh
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
print() { printf "*** %s ***\n" "$*"; }

RED="\e[1;31m"
GREEN="\e[1;32"
YELLOW="\e[1;33m"
NORMAL="\e[0m"

BUILD_ROOT="/BUILD"
BUILD_SOURCE="/opt/source"
BUILD_LOG="${BUILD_ROOT}/Zbuild_Logs"
BUILD_CMD="${BUILD_ROOT}/zbuild2.sh"

export RED GREEN YELLOW NORMAL
export BUILD_CMD BUILD_LOG BUILD_ROOT BUILD_SOURCE
export -f PackageCheck print

# end /etc/profile.d/zbuild.sh
