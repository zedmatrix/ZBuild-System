echo "Creating lfs:lfs"
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

echo "Enter password for user lfs"
passwd lfs

echo "Grant lfs full access to all directories"
chown -v lfs $LFS/{usr{,/*},var,etc,tools,zbuild}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
