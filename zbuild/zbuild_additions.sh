#!/bin/bash
# Additions to Fix zbuild2.0 scripts

#
# Global Settings
#
[ -z "${ZBUILD_root}" ] && { echo "Error: ZBUILD_root not set. Exiting."; exit 2; }
ZBUILD_log="${ZBUILD_root}/Zbuild_Logs"
ZBUILD_script="${ZBUILD_root}/zbuild2.sh"

packagedir=${package}
archive=$(find ${ZBUILD_sources} -name "${package}*.tar.*" | sort -V | head -1 | xargs basename)

Src_Extract() {
    zprint "Extracting: ${archive}"
    mkdir -v "${ZBUILD_root}/${packagedir}"
    tar -xf "${ZBUILD_sources}/${archive}" -C "${ZBUILD_root}/${packagedir}" --strip-components=1
}
# Executed After pushd into $ZBUILD_root/packagedir

make check 2>&1 | tee "${ZBUILD_log}/${packagedir}-check.log"

${ZBUILD_script} || { echo "Error: Missing ZBUILD_script."; exit 2; }
