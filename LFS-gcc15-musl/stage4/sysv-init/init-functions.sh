#!/bin/sh
# Begin /lib/lsb/init-functions
# Setup default values for environment
umask 022
export PATH="/bin:/usr/bin:/sbin:/usr/sbin"

DISTRO=${DISTRO:-"ZirconiumOS"}
DISTRO_CONTACT=${DISTRO_CONTACT:-"zedmatrix@libera.chat"}
DISTRO_MINI=${DISTRO_MINI:-"ZLFS_OS"}

ZNORM="\\033[0;39m"        # Standard console grey
ZPASS="\\033[1;32m"        # Success is green
ZWARN="\\033[1;33m"        # Warnings are yellow
ZFAIL="\\033[1;31m"        # Failures are red
ZINFO="\\033[1;36m"        # Information is light cyan
BRACKET="\\033[1;34m"      # Brackets are blue

# Use a colored prefix
BMPREFIX="      "
PASS_PREFIX="${ZPASS}  *  ${ZNORM} "
FAIL_PREFIX="${ZFAIL}*****${ZNORM} "
WARN_PREFIX="${ZWARN} *** ${ZNORM} "
SKIP_PREFIX="${INFO}  S   ${ZNORM}"

PASS_SUFFIX="${BRACKET}[${ZPASS} PASS ${BRACKET}]${ZNORM}"
FAIL_SUFFIX="${BRACKET}[${ZFAIL} FAIL ${BRACKET}]${ZNORM}"
WARN_SUFFIX="${BRACKET}[${ZWARN} WARN ${BRACKET}]${ZNORM}"
SKIP_SUFFIX="${BRACKET}[${ZINFO} SKIP ${BRACKET}]${ZNORM}"

# POSIX friendly
MAX_SIZE=$(stty size)
MAX_ROWS=${MAX_SIZE%% *}
MAX_COLS=${MAX_SIZE##* }

if [ ${MAX_COLS} = "0" ]; then
    MAX_COLS=80
fi

## Measurements for positioning result messages
LEFT_COL=$((${MAX_COLS} - 8))
RIGHT_COL=$((${LEFT_COL} - 2))

## Set Cursor Position Commands, used via echo
SET_LEFT="\\033[${LEFT_COL}G"      # at the $LEFT_COL char
SET_RIGHT="\\033[${RIGHT_COL}G"    # at the $RIGHT_COL char
CURS_UP="\\033[1A\\033[0G"         # Up one line, at the 0'th char
CURS_ZERO="\\033[0G"

timespec() {
   STAMP="$(echo `date +"%b %d %T %:z"` `hostname`) "
   return 0
}
message_pass() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${PASS_PREFIX}${SET_LEFT}${PASS_SUFFIX}"
    logmessage=`echo "${@}" | sed 's/\\\033[^a-zA-Z]*.//g'`
    timespec
    /bin/echo -e "${STAMP} ${logmessage} PASS" >> ${BOOTLOG}
}
message_fail() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${FAIL_PREFIX}${SET_LEFT}${FAIL_SUFFIX}"
    logmessage=`echo "${@}" | sed 's/\\\033[^a-zA-Z]*.//g'`
    timespec
    /bin/echo -e "${STAMP} ${logmessage} FAIL" >> ${BOOTLOG}
}
message_warn() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${WARN_PREFIX}${SET_LEFT}${WARN_SUFFIX}"
    logmessage=`echo "${@}" | sed 's/\\\033[^a-zA-Z]*.//g'`
    timespec
    /bin/echo -e "${STAMP} ${logmessage} WARN" >> ${BOOTLOG}
}
message_skip() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${SKIP_PREFIX}${SET_LEFT}${SKIP_SUFFIX}"
}
message_info() {
    /bin/echo -n -e "${BMPREFIX}${@}"
    logmessage=`echo "${@}" | sed 's/\\\033[^a-zA-Z]*.//g'`
    timespec
    /bin/echo -e "${STAMP} ${logmessage}" >> ${BOOTLOG}
}
BOOTLOG=/run/bootlog
KILLDELAY=3
start_daemon() {
    local program="$1"
    shift

    # Check if the program exists
    if [ ! -x "$program" ]; then
        message_fail "Daemon not found: $program"
        return 1
    fi

    # Use default nice value if not set
    local N="${nice:-0}"

    # Launch the daemon
    if [ "$background" = "yes" ]; then
        nice -n "$N" "$program" "$@" &
    else
        nice -n "$N" "$program" "$@"
    fi

    local ret=$?
    if [ "$ret" -eq 0 ]; then
        message_pass "Started $program"
    else
        message_fail "Failed to start $program"
    fi

    return "$ret"
}
killproc() {
    local program="$1"
    shift

    # If '-x' is passed, shift again and treat next argument as the name
    if [ "$1" = "-x" ]; then
        shift
        program="$1"
        shift
    fi

    local pid
    pid=$(pidof "$program")

    if [ -n "$pid" ]; then
        kill "$@" "$pid"
        message_pass "Stopped $program"
    else
        message_skip "$program not running"
    fi
}

status_proc() {
    local program="$1"

    if pgrep -x "$(basename "$program")" > /dev/null; then
        message_pass "$program is running"
        return 0
    else
        message_warn "$program is not running"
        return 1
    fi
}
# End /lib/lsb/init-functions
