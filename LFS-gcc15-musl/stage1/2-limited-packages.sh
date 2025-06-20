# Prepare Cross Compile Environment
print "Getting Limited Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
LC_ALL=POSIX
LFS_TGT=${LFS_TGT:-$(uname -m)-lfs-linux-musl}
SOURCES=${SOURCES:-$LFS/sources}

PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site

print() { printf "%s\n" "$*"; }
download() {
    # Usage: $1 = file , $2 = url , $3 = md5
    local file=$1
    local url=$2
    local md5=$3
    print "Checking for $file ..."
    wget -nc -P $SOURCES "${url}"
    local newmd5=$(md5sum "$SOURCES/$file" | awk '{print $1}')
    echo "$newmd5 $file" >> md5sums
    [[ $newmd5 == $md5 ]] && print "Ok" || print "Fail $newmd5"
}
while IFS= read -r url; do
    archive=$(basename $url)
    echo "Archive: $archive URL: $url"
    download "$archive" "$url"
done < source_list.txt
