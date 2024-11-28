#!/bin/bash
# Additions to Fix zbuild2.0 scripts

#
# Global Settings
#
[ -z "${ZBUILD_root}" ] && { echo "Error: ZBUILD_root not set. Exiting."; return 2; }
ZBUILD_log=${ZBUILD_log:-"${ZBUILD_root}/Zbuild_log"}
ZBUILD_script=${ZBUILD_script:-"${ZBUILD_root}/zbuild2.sh"}

packagedir=${package}
archive=$(find ${ZBUILD_sources} -name "${package}*.tar.*" | sort -V | head -1 | xargs basename)

Src_Extract() {
    zprint "Extracting: ${archive}"
    mkdir -v "${ZBUILD_root}/${packagedir}"
    tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}
# Executed After pushd into $ZBUILD_root/packagedir

make check 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"

if [ -f ${ZBUILD_script} ]; then
    ${ZBUILD_script}
else
    zprint "Error: Missing ZBUILD_script."
    return 2
fi

#grep -v '^#' ../lib-7.md5 | awk '{print $2}' | wget - -c -P /mnt/lfs/sources
Source_wget() {
	if [ -z $1 ]; then
		 echo "Atleast one argument is needed"
	else
		wget $1 --no-clobber --rejected-log=${ZBUILD_log}/wget_rejects.log -P ${ZBUILD_sources}
	fi
}
