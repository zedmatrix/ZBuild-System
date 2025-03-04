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
