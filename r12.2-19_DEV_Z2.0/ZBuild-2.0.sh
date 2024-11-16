#!/bin/bash
#       ZBuild script v2.0 - Linux From Scratch - revised 16-Nov-2024
#
# REQUIRES: ZBUILD_root, ZBUILD_sources, ZBUILD_log
#
# To-Do: ZBUILD_user, ZBUILD_group
#
#   All Functions Should Be Defined even if just with an echo statement
#
#   Requires ${archive}, ${package}, ${packagedir}
fail() {
    local exitcode="${2:-1}"
    echo "Exiting with code $exitcode: $1"
    exit $exitcode
}
bail() { echo "Error: $*"; exit 1; }
warn() { echo "Warning: $*"; }
zprint() { printf "${YELLOW} *** %s *** ${NORMAL} \n" "$*"; }

[ -z "$archive" ] && bail "Archive not set"
[ -z "$package" ] && bail "Package not set"
[ -z "$packagedir" ] && bail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "${ZBUILD_sources}/${archive}" ] && bail "Missing Source Archive"

pushd "${ZBUILD_root}"

    if declare -f Src_Extract > /dev/null; then
        Src_Extract || bail "Extraction: $?"
    else
        zprint "*** Skipping Extraction ***"
    fi

    [ ! -d "${ZBUILD_root}/${packagedir}" ] && bail "${packagedir} Failure $?"

    pushd "${ZBUILD_root}/${packagedir}"

# Run a $patch if set
        if [ ! "${patch}" = "false" ] && [ -f "${ZBUILD_sources}/${patch}" ]; then
            zprint " Patching ${package} with ${patch} "
            patch -Np1 -i "${ZBUILD_sources}/${patch}" || bail "Patching Failed $?"
        else
            zprint " Skipping Patch "
        fi

# Src_prepare or just warning
        Src_prepare || warn "Src_prepare not set."

# Src_configure
        if declare -f Src_configure > /dev/null; then
            Src_configure || bail "Configure: $?"
        else
            fail "Src_configure not set." 88
        fi

# Src_compile
        if declare -f Src_compile > /dev/null; then
            Src_compile || bail "Compile: $?"
        else
            fail "Src_compile not set." 77
        fi

# Src_Check
        if declare -f Src_check > /dev/null; then
            Src_check
        else
            fail "Src_check not set. exiting." 66
        fi

# Src_install
        if declare -f Src_install > /dev/null; then
            Src_install || bail "Install Failure ${package}: $?"
        else
            fail "Src_install not set. Exiting." 55
        fi

# back to ZBUILD_root
        popd

# Src_post function
    Src_post || warn "Src_post not set."

    if [ "${delete}" = "true" ]; then
        zprint " Cleaning Up ${ZBUILD_root}/${packagedir} ***"
        rm -rf "${ZBUILD_root}/${packagedir}"
    else
        zprint " Not Removing Build Extract Folder "
    fi

popd # back to $PWD
zprint " Zbuild Finished."
