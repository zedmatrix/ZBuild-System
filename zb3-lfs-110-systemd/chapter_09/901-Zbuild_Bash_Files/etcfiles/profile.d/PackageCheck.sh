#!/bin/bash
PackageCheck() {
    pkg=$1
    [ -z $pkg ] && { echo "Usage: PackageCheck 'Package Name' "; exit 1; }

    printf "Checking For... (%s)" "${pkg}"

    if $(pkg-config --exists "$pkg"); then
        ver=$(pkg-config --modversion "${pkg}")
        printf "... True (%s)\n" "${ver}"
    else
        printf "... False\n"
    fi
}
export -f PackageCheck
