#!/bin/bash
# ZBuild script v2.0 - Linux From Scratch
#   Source zbuild_env.sh or add it to /etc/profile.d
# REQUIRES: BUILD_ROOT, BUILD_SOURCE, BUILD_LOG
# To-Do: BUILD_USER, BUILD_GROUP
#
#   All Functions Should Be Defined even if just with an echo statement
#
#   Requires ${archive}, ${package}, ${packagedir}
fail() {
    local exitcode="${2:-1}"
    print " Exiting with code $exitcode: $1"
    exit $exitcode
}
bail() { print "${RED} Bailing: $* ${NORMAL}"; exit 1; }
warn() { print "${YELLOW} Warning: $* ${NORMAL}"; }
stars() { printf "${GREEN}"; printf '%.0s*' {1..30}; printf "${NORMAL}\n"; }

[ -z "$archive" ] && bail "Archive not set"
[ -z "$package" ] && bail "Package not set"
[ -z "$packagedir" ] && bail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "$BUILD_SOURCE/$archive" ] && bail "Missing Source Archive"

pushd $BUILD_ROOT
	stars
    if declare -f Src_Extract > /dev/null; then
        Src_Extract || bail "Extraction: $?"
    else
        print "Skipping Extraction"
    fi

    [ ! -d "$BUILD_ROOT/$packagedir" ] && bail "$packagedir Failure $?"

    pushd $BUILD_ROOT/$packagedir

# Run a $patch if set
        if [ ! "$patch" = "false" ] && [ -f "${BUILD_SOURCE}/${patch}" ]; then
            print "Patching ${package} with ${patch}"
            patch -Np1 -i "${BUILD_SOURCE}/${patch}" || bail "Patching Failed $?"
        else
            print "Skipping Patch"
        fi

# Src_prepare or just warning
        type -t Src_prepare &>/dev/null && Src_prepare || warn "Src_prepare not set."

# Src_configure
        if declare -f Src_configure > /dev/null; then
            Src_configure || bail "Configure: $?"
        else
            fail "Src_configure not set. Exiting." 88
        fi

# Src_compile
        if declare -f Src_compile > /dev/null; then
            Src_compile || bail "Compile: $?"
        else
            fail "Src_compile not set. Exiting." 77
        fi

# Src_Check
        if declare -f Src_check > /dev/null; then
            Src_check
        else
            fail "Src_check not set. Exiting." 66
        fi

# Src_install
        if declare -f Src_install > /dev/null; then
            Src_install || bail "Install Failure ${package}: $?"
        else
            fail "Src_install not set. Exiting." 55
        fi

# back to BUILD_ROOT
        popd

# Src_post function
    type -t Src_post &>/dev/null && Src_post || warn "Src_post not set."

    if [ "$delete" = "true" ]; then
        print "Cleaning Up ${BUILD_ROOT}/${packagedir}"
        rm -rf ${BUILD_ROOT}/${packagedir}
    else
        print "Not Removing Source Folder"
    fi

popd # pop the BUILD_ROOT
print "Zbuild Finished."
stars
# The End
