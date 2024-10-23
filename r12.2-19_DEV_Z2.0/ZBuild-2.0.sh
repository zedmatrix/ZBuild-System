#!/bin/bash
# ZBuild script v2.0 - Linux From Scratch
# REQUIRES: BUILD_ROOT, BUILD_SOURCE, BUILD_LOGS
# To-Do: BUILD_USER, BUILD_GROUP
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

[ -z "$archive" ] && bail "Archive not set"
[ -z "$package" ] && bail "Package not set"
[ -z "$packagedir" ] && bail "Packagedir not set"

#   verify the archive is in BUILD_SOURCE
[ ! -e "$BUILD_SOURCE/$archive" ] && bail "Missing Source Archive"

pushd $BUILD_ROOT

    if declare -f Src_Extract > /dev/null; then
        Src_Extract || bail "Extraction: $?"
    else
        echo "*** Skipping Extraction ***"
    fi

    [ ! -d "$BUILD_ROOT/$packagedir" ] && bail "$packagedir Failure $?"

    pushd $BUILD_ROOT/$packagedir

# Run a $patch if set
        if [ ! "$patch" = "false" ] && [ -f $BUILD_SOURCE/$patch ]; then
            echo "*** Patching $package with $patch ***"
            patch -Np1 -i "$BUILD_SOURCE/$patch" || bail "Patching Failed $?"
        else
            echo "*** Skipping Patch ***"
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

# back to BUILD_ROOT
        popd

# Src_post function
    Src_post || warn "Src_post not set."

    if [ "$delete" = "true" ]; then
        echo "*** Cleaning Up $BUILD_ROOT/${packagedir} ***"
        rm -rf $BUILD_ROOT/${packagedir}
    else
        echo "*** Not Removing Source Folder ***"
    fi

popd # pop the BUILD_ROOT
echo "*** Zbuild Finished.***"
