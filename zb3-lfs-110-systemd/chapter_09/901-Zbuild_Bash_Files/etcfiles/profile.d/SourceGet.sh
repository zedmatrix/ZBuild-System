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
