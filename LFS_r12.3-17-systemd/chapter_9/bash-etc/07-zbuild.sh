cat > /etc/profile.d/zbuild_environment.sh << "EOF"
###################################
# Begin /etc/profile.d/zbuild_environment.sh

zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zzcyan="${zzcyan:-\033[1;36m}"
zznormal="${zznormal:-\033[0m}"

ZBUILD_root="/zbuild"
ZBUILD_sources="/sources"
ZBUILD_log="${ZBUILD_root}/Zbuild_log"
ZBUILD_script="${ZBUILD_root}/zbuild4.sh"

zprint() { printf "${zzgreen} *** %s *** ${zznormal}\n" "$*"; }

export zzred zzcyan zzgreen zzyellow zznormal
export ZBUILD_root ZBUILD_sources ZBUILD_script ZBUILD_log
export -f zprint

# End /etc/profile.d/zbuild_environment.sh
###################################
EOF
[ -f /etc/profile.d/zbuild_environment.sh ] && echo " Created /etc/profile.d/zbuild_environment.sh "

cat > /etc/profile.d/SourceGet.sh << "EOF"
#!/bin/bash
SourceGet() {
    if [[ -z $1 ]]; then
        printf "${zzred} Usage: Source_wget [url/file] ${zznormal} \n"
        return 1
    fi

    local url=$1
    wget "$url" --no-clobber \
        -P "${ZBUILD_sources}" || printf "${zzred} Failed to download $url Error[%s] ${zznormal} \n " $?
}
export -f SourceGet
EOF
[ -f /etc/profile.d/SourceGet.sh ] && echo " Created /etc/profile.d/SourceGet.sh "

cat > /etc/profile.d/CurlPaste.sh << "EOF"
#!/bin/bash
CurlPaste() {
    local file=$1
    if [[ -z $file ]]; then
        printf "${zzred} Error:\n Usage: CurlPaste [file] ${zznormal} \n"
        return 1
    fi

    if [[ -f $file ]]; then
        printf "${zzgreen} Uploading ${file} ${zznormal} \n"
        curl -F'file=@-' https://0x0.st < "${file}"
    else
        printf "${zzyellow} Warning: File does not exist. ${zznormal} \n"
        return 1
    fi
}
export -f CurlPaste
EOF
[ -f /etc/profile.d/CurlPaste.sh ] && echo " Created /etc/profile.d/CurlPaste.sh "

