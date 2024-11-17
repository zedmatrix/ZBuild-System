#!/bin/bash
bail() { print "$*"; exit 1; }
usage() {
	print "wget.list = {MD5} {Base URL} {Archive}"
	print "$0 <wget.list>"
	bail "Missing WGET list"
}

_getfile=${1}
WGET="${PWD}/${_getfile}"
[ ! -f "$WGET" ] && usage

LOG="${ZBUILD_log}/wget_${_getfile}.log"

SOURCE="${ZBUILD_sources}"
[ ! -d "$SOURCE" ] && bail "Missing \$SOURCE directory"

while read -r md5 url file; do

    [[ "$md5" =~ ^#.*$ || -z "$md5" ]] && continue

    package_url="${url}/${file}"
    download_file="${SOURCE}/${file}"

	if [ ! -f "${download_file}" ]; then
	    print "Downloading: $package_url"
    	wget -P "${SOURCE}" "${package_url}" --continue
	else
		print "Skipping: ${file} ...Exists."
  		echo "Skipping Existing: ${file}" >> $LOG
	fi

    if echo "$md5  $download_file" | md5sum -c -; then
        echo "File: $file MD5 checksum: OK" >> $LOG
    else
        echo "File: $file MD5 checksum: FAIL" >> $LOG
    fi
done < <(grep -v '^#' "$WGET")

fail="Fail: $(grep 'FAIL' "$LOG" | wc -l)"
print "All Downloads Completed. $fail"
