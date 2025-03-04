#!/bin/bash
#   ZBuild script v3.0 - Linux From Scratch - r12.2-110-systemd
#   Source zb3_environment.sh or add it to /etc/profile.d
#
# REQUIRES: ZBUILD_root, ZBUILD_sources, ZBUILD_log, zprint function
# 	zzred, zzgreen, zzyellow, zznormal
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
zzbail() {
    local exitcode="${2:-1}"
    printf "${zzred}*** Bailing: $* ***${zznormal}\n"
    exit $exitcode
}
zzwarn() { printf "${zzyellow}*** Warning: $* ***${zznormal}\n"; }
zzstars() { printf "${zzgreen}"; printf '%.0s*' {1..30}; printf "${zznormal}\n"; }

[ -z "$archive" ] && zzbail "Archive not set" 1
[ -z "$package" ] && zzbail "Package not set" 2
[ -z "$packagedir" ] && zzbail "Packagedir not set" 3

#   verify the archive is in ZBUILD_sources
[ ! -e "$ZBUILD_sources/$archive" ] && zzbail "Missing Source Archive" 99

pushd $ZBUILD_root
    zzstars
    if declare -f Src_Extract > /dev/null; then
    	zprint " Extracting: ${archive} to ${packagedir} "
        Src_Extract || zzbail "Extraction:" $?
    else
        zprint " Src_Extract Not Set. Skipping "
    fi

    [ ! -d "$ZBUILD_root/$packagedir" ] && zzbail "$packagedir Failure" 99
    pushd "$ZBUILD_root/$packagedir"

# Run a $patch if set
        if [ ! "$patch" = "false" ] && [ -f "${ZBUILD_sources}/${patch}" ]; then
            zprint "Patching ${packagedir} with ${patch}"
            patch -Np1 -i "${ZBUILD_sources}/${patch}" || zzbail "Patch Failed" $?
        else
            zprint " Patch Not Set. Skipping. "
        fi

# Src_prepare function (sed, mkdir/cd)
		if declare -f Src_prepare > /dev/null; then
			zprint " Intializing ${packagedir} "
	        Src_prepare || zzwarn "Prepare: $?"
	    else
	    	zprint " Src_prepare not set. Skipping. "
	    fi

# Src_configure (configure/meson/cmake)
        if declare -f Src_configure > /dev/null; then
        	zprint " Configuring ${packagedir} "
            Src_configure || zzbail "Configure:" $?
        else
            zzfail "Src_configure not set. Exiting." 88
        fi

# Src_compile (make/ninja)
        if declare -f Src_compile > /dev/null; then
        	zprint " Compiling ${packagedir} "
            Src_compile || zzbail "Compile:" $?
        else
            zzfail "Src_compile not set. Exiting." 77
        fi

# Src_check (make/ninja)
        if declare -f Src_check > /dev/null; then
        	zprint " Checking ${packagedir} "
            Src_check || zzwarn "Check: $?"
        else
        	zprint " No Testsuite Available "
            #zzfail "Src_check not set. Exiting." 66
        fi

# Src_install (make/ninja)
        if declare -f Src_install > /dev/null; then
        	zprint " Installing ${packagedir} "
            Src_install || zzbail "Install Failure ${package}:" $?
        else
            zzfail "Src_install not set. Exiting." 55
        fi

# Src_post function (document intalls)
		if declare -f Src_post > /dev/null; then
			zprint " Finalizing ${packagedir} "
	        Src_post || zzwarn "Post: $?"
	    else
	    	zprint " Skipping unset function Src_post. "
	    fi

# back to ZBUILD_root
        popd

    if [ "$delete" = "true" ]; then
        zprint "Cleaning Up ${ZBUILD_root}/${packagedir}"
        rm -rf ${ZBUILD_root}/${packagedir}
    else
        zprint " Not Removing Source Folder "
    fi

popd # backto PWD
if [ -z $LFS ]; then
	zprint "Executing ldconfig"
	if [ "$EUID" -eq 0 ]; then
	    /usr/sbin/ldconfig
	elif command -v sudo &>/dev/null; then
	    sudo /usr/sbin/ldconfig
	else
	    su -c "/usr/sbin/ldconfig"
	fi
fi
zprint "Zbuild Finished."
zzstars
# The End
