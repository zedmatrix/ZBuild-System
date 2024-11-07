#!/bin/bash
#export BUILD_SOURCE="/opt/source"
_checkfile() {
    local _file="${1}"
    local _path="${2}"
    printf 'Checking for %s...' ${_file}
    package=$(find ${_path} -name "${_file}*.t*" | sort -V | head -1)
    if [ -f "${package}" ]; then
        _yes "$(basename ${package})"
    else
        warn "Missing ${_file}"
        _no
    fi
}
_checkzbuild() {
    local _file="${1}"
    printf 'Checking for (%s) zbuild...' ${_file}
	zbuild=$(find ${_root} -name "*${_file}*.zbuild")
    if [ -f "${zbuild}" ]; then
        _yes "$(basename ${zbuild})"
    else
        _no
    fi

}
_checkvar() {
    local _var=$1
    printf 'Checking for %s...' ${_var}
    if [ -n "${!_var}" ]; then
        _yes "...${!_var}"
    else
        _no
    fi
}
_yes() { printf '(%s) \n' " $* ...Yes "; }
_no()  { printf '%s \n' " ...No "; }
warn() { printf '%s ...' " $* "; }
bail() { echo "$* Error: $?"; exit 1; }
usage() { printf " \nUsage $0: package list \n\tA list of package name to check\n"; bail "Exiting."; }

#check package list
_root=${PWD}
[ $# -ne 1 ] && usage

_packagelist=$1
print "$_packagelist"
[ ! -f "${_root}/${_packagelist}" ] && bail "File Doesn't Exist."

_checkvar "BUILD_SOURCE" || bail "${_var} Not Set"
printf "========================\n"

while read -r _pkg; do
    _checkfile "${_pkg}" "${BUILD_SOURCE}"
done < "${_root}/${_packagelist}"

printf "========================\n"

while read -r _pkg; do
	_checkzbuild "${_pkg}"
done < "${_root}/${_packagelist}"
