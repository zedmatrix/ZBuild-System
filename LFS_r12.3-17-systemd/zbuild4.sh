#!/bin/bash
# ZBuild script v3.4 - Linux From Scratch
zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zzmagenta="${zzmagenta:-\033[1;35m}"
zzreset="${zzreset:-\033[0m}"
ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
# requires
# pkgname pkgver pkgurl pkgpatch
# zdelete zconfig
#
zzprint() { printf "${zzgreen}*** %s ***${zzreset}\n" "$*"; }
zzfail() {
    local exitcode="${2:-1}"
    printf "${zzred} Exiting with code $exitcode: $1 ${zzreset} \n"
    exit $exitcode
}
zzbail() {
    local exitcode="${2:-1}"
	printf "${zzred}*** Bailing: $* ***${zzreset}\n"
	exit $exitcode
}
zzwarn() { printf "${zzyellow} *** Warning: $* *** ${zzreset} \n"; }
zzstars() { printf " ${zzmagenta} "; printf '%.0s*' {1..30}; printf " ${zzreset} \n"; }

# Ensure pkgname - pkgver - pkgurl is set
if [[ -z "$pkgname" || -z "$pkgver" || -z "$pkgurl" ]]; then
    zzbail "Package not set" 127
fi

packagedir="${pkgname}-${pkgver}"
zpackages="${ZBUILD_root}/zpackages/zbuild.db"
# Enter build root
pushd $ZBUILD_root
    zzstars
    mkdir -v "${ZBUILD_root}/${packagedir}"

    archive_name=$(basename "$pkgurl")
    archive=$(find "${ZBUILD_sources}" -name "$archive_name" | head -1)

    if [ -z "$archive" ]; then
        zzbail "Failed to get archive" 127
    fi

    case $archive in
    *.tar.gz|*.tar.bz2|*.tar.xz|*.tgz|*.tar.lzma)
        zzprint " Extracting: ${archive} to ${packagedir} "
        tar -xf "$archive" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
        ;;
    *)
        zzbail "Unsupported archive format: $archive" 128
        ;;
    esac

    [ ! -d "$ZBUILD_root/$packagedir" ] && zzbail "$packagedir Failure" 99
    pushd "$ZBUILD_root/$packagedir"

# Run a $pkgpatch if set
        if [[ -n "$pkgpatch" && -f "${ZBUILD_sources}/${pkgpatch}" ]]; then
            zzprint " Patching ${packagedir} with ${pkgpatch}"
            patch -Np1 -i "${ZBUILD_sources}/${pkgpatch}" || zzbail "Patch Failed" $?
        else
            zzprint " Patch Not Set. Skipping. "
        fi

# Src_prepare function (sed, mkdir/cd)
		if declare -f Src_prepare > /dev/null; then
			zzprint " Intializing ${packagedir} "
	        Src_prepare || zzwarn $?
	    else
	    	zzprint " Src_prepare not set. Skipping. "
	    fi

# Src_configure (configure/meson/cmake)
        if declare -f Src_configure > /dev/null; then
        	zzprint " Configuring ${packagedir} "
            Src_configure || zzbail "Configure:" $?
        else
            zzfail "Src_configure not set. Exiting." 88
        fi

# Src_compile (make/ninja)
        if declare -f Src_compile > /dev/null; then
        	zzprint " Compiling ${packagedir} "
            Src_compile || zzbail "Compile:" $?
        else
            zzfail "Src_compile not set. Exiting." 77
        fi

# Src_check (make check/ninja test)
        if declare -f Src_check > /dev/null; then
        	zzprint " Checking ${packagedir} "
            Src_check || zzwarn $?
        else
        	zzprint " No Testsuite Available "
        fi

# Src_install (make/ninja)
        if declare -f Src_install > /dev/null; then
        	zzprint " Installing ${packagedir} "
			Src_install || zzbail "Install Failure ${packagedir}: $?"
        else
            zzfail "Src_install not set. Exiting." 55
        fi

# Src_post function (document intalls)
		if declare -f Src_post > /dev/null; then
			zzprint " Finalizing ${packagedir} "
	        Src_post || zzwarn $?
	    else
	    	zzprint " Src_post not set. Skipping. "
	    fi

# back to ZBUILD_root
        popd

    if [[ "$zdelete" = "true" ]]; then
        zzprint "Cleaning Up ${ZBUILD_root}/${packagedir}"
        rm -rf ${ZBUILD_root}/${packagedir}
    else
        zprint " Not Removing Source Folder "
    fi

popd # backto PWD
printf "\n $pkgname - $pkgver - $pkgurl \n"
echo "$pkgname - $pkgver - $pkgurl" >> $zpackages
zzprint "Zbuild Finished."
zzstars
# The End
