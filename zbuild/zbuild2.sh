#!/bin/bash
# ZBuild script v2.0 - Linux From Scratch
#   Source zbuild_env.sh or add it to /etc/profile.d
#
# REQUIRES: ZBUILD_root, ZBUILD_sources, ZBUILD_log, zprint function
# 	zzred, zzgreen, zzyellow, zznormal
# To-Do: ZBUILD_user, ZBUILD_group
#   rename patch and delete to prepend ZBUILD_
#
#   All Functions Should Be Defined even if just with an echo statement
#
#   Requires ${archive}, ${package}, ${packagedir}
#
zzfail() {
    local exitcode="${2:-1}"
    zprint " Exiting with code $exitcode: $1"
    exit $exitcode
}
zzbail() { zprint "${zzred} Bailing: $* ${zznormal}"; exit 1; }
zzwarn() { zprint "${zzyellow} Warning: $* ${zznormal}"; }
zzstars() { printf "${zzgreen}"; printf '%.0s*' {1..30}; printf "${zznormal}\n"; }

[ -z "$archive" ] && zzbail "Archive not set"
[ -z "$package" ] && zzbail "Package not set"
[ -z "$packagedir" ] && zzbail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "$ZBUILD_sources/$archive" ] && zzbail "Missing Source Archive"

pushd $ZBUILD_root
    zzstars
    if declare -f Src_Extract > /dev/null; then
        Src_Extract || zzbail "Extraction: $?"
    else
        zprint "Skipping Extraction"
    fi

    [ ! -d "$ZBUILD_root/$packagedir" ] && zzbail "$packagedir Failure $?"

    pushd $ZBUILD_root/$packagedir

# Run a $patch if set
        if [ ! "$patch" = "false" ] && [ -f "${ZBUILD_sources}/${patch}" ]; then
            zprint "Patching ${package} with ${patch}"
            patch -Np1 -i "${ZBUILD_sources}/${patch}" || zzbail "Patching Failed $?"
        else
            zprint "Skipping Patch"
        fi

# Src_prepare function (sed, mkdir/cd)
        type -t Src_prepare &>/dev/null && Src_prepare || zzwarn "Src_prepare not set."

# Src_configure (configure/meson/cmake)
        if declare -f Src_configure > /dev/null; then
            Src_configure || zzbail "Configure: $?"
        else
            zzfail "Src_configure not set. Exiting." 88
        fi

# Src_compile (make/ninja)
        if declare -f Src_compile > /dev/null; then
            Src_compile || zzbail "Compile: $?"
        else
            zzfail "Src_compile not set. Exiting." 77
        fi

# Src_check (make/ninja)
        if declare -f Src_check > /dev/null; then
            Src_check || zzwarn "Warning: $?"
        else
            zzfail "Src_check not set. Exiting." 66
        fi

# Src_install (make/ninja)
        if declare -f Src_install > /dev/null; then
            Src_install || zzbail "Install Failure ${package}: $?"
        else
            zzfail "Src_install not set. Exiting." 55
        fi

# Src_post function (document intalls)
        type -t Src_post &>/dev/null && Src_post || zzwarn "Src_post not set."

# back to ZBUILD_root
        popd

    if [ "$delete" = "true" ]; then
        zprint "Cleaning Up ${ZBUILD_root}/${packagedir}"
        rm -rf ${ZBUILD_root}/${packagedir}
    else
        zprint "Not Removing Source Folder"
    fi

popd # backto PWD
zprint "Zbuild Finished."
zzstars
# The End
