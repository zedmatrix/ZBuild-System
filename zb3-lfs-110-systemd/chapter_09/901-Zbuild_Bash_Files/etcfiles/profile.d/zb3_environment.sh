###################################
# Begin /etc/profile.d/zbuild3.sh

zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zzcyan="${zzcyan:-\033[1;36m}"
zznormal="${zznormal:-\033[0m}"

ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild3.sh"

zprint() { printf "${zzcyan} *** %s *** ${zznormal}\n" "$*"; }

export zzred zzcyan zzgreen zzyellow
export ZBUILD_root ZBUILD_sources ZBUILD_script ZBUILD_log
export -f zprint

# End /etc/profile.d/zbuild3.sh
###################################
