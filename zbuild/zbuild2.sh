#!/bin/bash
# ZBuild script v2.0 - Linux From Scratch
#   Source zbuild_env.sh or add it to /etc/profile.d
#
# REQUIRES: ZBUILD_root, ZBUILD_sources, ZBUILD_log, zprint function
#
# To-Do: ZBUILD_user, ZBUILD_group
#   rename patch and delete to prepend ZBUILD_
#
#   All Functions Should Be Defined even if just with an echo statement
#
#   Requires ${archive}, ${package}, ${packagedir}
#
fail() {
    local exitcode="${2:-1}"
    zprint " Exiting with code $exitcode: $1"
    exit $exitcode
}
bail() { zprint "${RED} Bailing: $* ${NORMAL}"; exit 1; }
warn() { zprint "${YELLOW} Warning: $* ${NORMAL}"; }
stars() { printf "${GREEN}"; printf '%.0s*' {1..30}; printf "${NORMAL}\n"; }

[ -z "$archive" ] && bail "Archive not set"
[ -z "$package" ] && bail "Package not set"
[ -z "$packagedir" ] && bail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "$ZBUILD_sources/$archive" ] && bail "Missing Source Archive"

pushd $ZBUILD_root
	stars
    if declare -f Src_Extract > /dev/null; then
        Src_Extract || bail "Extraction: $?"
    else
        zprint "Skipping Extraction"
    fi

    [ ! -d "$ZBUILD_root/$packagedir" ] && bail "$packagedir Failure $?"

    pushd $ZBUILD_root/$packagedir

# Run a $patch if set
        if [ ! "$patch" = "false" ] && [ -f "${ZBUILD_sources}/${patch}" ]; then
            zprint "Patching ${package} with ${patch}"
            patch -Np1 -i "${ZBUILD_sources}/${patch}" || bail "Patching Failed $?"
        else
            zprint "Skipping Patch"
        fi

# Src_prepare function (sed, mkdir/cd)
        type -t Src_prepare &>/dev/null && Src_prepare || warn "Src_prepare not set."

# Src_configure (configure/meson/cmake)
        if declare -f Src_configure > /dev/null; then
            Src_configure || bail "Configure: $?"
        else
            fail "Src_configure not set. Exiting." 88
        fi

# Src_compile (make/ninja)
        if declare -f Src_compile > /dev/null; then
            Src_compile || bail "Compile: $?"
        else
            fail "Src_compile not set. Exiting." 77
        fi

# Src_check (make/ninja)
        if declare -f Src_check > /dev/null; then
            Src_check || warn "Warning: $?"
        else
            fail "Src_check not set. Exiting." 66
        fi

# Src_install (make/ninja)
        if declare -f Src_install > /dev/null; then
            Src_install || bail "Install Failure ${package}: $?"
        else
            fail "Src_install not set. Exiting." 55
        fi

# Src_post function (document intalls)
        type -t Src_post &>/dev/null && Src_post || warn "Src_post not set."

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
stars
# The End
