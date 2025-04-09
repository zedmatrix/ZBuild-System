grep -v '^#' wget-additional | awk '{print $2}' | wget -i- -c -nc -P $LFS/sources
