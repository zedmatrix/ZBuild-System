#!/bin/bash
#       ZBuild script v2.0 - Linux From Scratch - revised 16-Nov-2024
#    function renames zzfail, zzbail, zzwarn, zzprint
# REQUIRES: ZBUILD_root, ZBUILD_sources, ZBUILD_log
#
# To-Do: ZBUILD_user, ZBUILD_group
#
#   All Functions Should Be Defined even if just with an echo statement
#    zzred, zzgreen, zzyellow, zznormal
#   Requires ${archive}, ${package}, ${packagedir}
zzfail() {
    local exitcode="${2:-1}"
    echo "Exiting with code $exitcode: $1"
    exit $exitcode
}
zzbail() { zzprint "Error: $*"; exit 1; }
zzwarn() { zzprint "Warning: $*"; }
zzprint() { printf "${zzyellow} *** %s *** ${zznormal} \n" "$*"; }

[ -z "$archive" ] && zzbail "Archive not set"
[ -z "$package" ] && zzbail "Package not set"
[ -z "$packagedir" ] && zzbail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "${ZBUILD_sources}/${archive}" ] && zzbail "Missing Source Archive"

pushd "${ZBUILD_root}"

    if declare -f Src_Extract > /dev/null; then
        Src_Extract || zzbail "Extraction: $?"
    else
        zzprint "*** Skipping Extraction ***"
    fi

    [ ! -d "${ZBUILD_root}/${packagedir}" ] && zzbail "${packagedir} Failure $?"

    pushd "${ZBUILD_root}/${packagedir}"

# Run a $patch if set
        if [ ! "${patch}" = "false" ] && [ -f "${ZBUILD_sources}/${patch}" ]; then
            zzprint " Patching ${package} with ${patch} "
            patch -Np1 -i "${ZBUILD_sources}/${patch}" || zzbail "Patching Failed $?"
        else
            zzprint " Skipping Patch "
        fi

# Src_prepare or just warning
        Src_prepare || zzwarn "Src_prepare not set."

# Src_configure
        if declare -f Src_configure > /dev/null; then
            Src_configure || zzbail "Configure: $?"
        else
            zzfail "Src_configure not set." 88
        fi

# Src_compile
        if declare -f Src_compile > /dev/null; then
            Src_compile || zzbail "Compile: $?"
        else
            zzfail "Src_compile not set." 77
        fi

# Src_Check
        if declare -f Src_check > /dev/null; then
            Src_check
        else
            zzfail "Src_check not set. exiting." 66
        fi

# Src_install
        if declare -f Src_install > /dev/null; then
            Src_install || zzbail "Install Failure ${package}: $?"
        else
            zzfail "Src_install not set. Exiting." 55
        fi

# back to ZBUILD_root
        popd

# Src_post function
    Src_post || warn "Src_post not set."

    if [ "${delete}" = "true" ]; then
        zzprint " Cleaning Up ${ZBUILD_root}/${packagedir} "
        rm -rf "${ZBUILD_root}/${packagedir}"
    else
        zzprint " Not Removing Build Extract Folder "
    fi

popd # back to $PWD
zzprint " Zbuild Finished."
