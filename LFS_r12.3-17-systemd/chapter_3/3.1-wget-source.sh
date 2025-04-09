mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources
