printf "\n\t 7.13. Cleaning up and Saving the Temporary System \n"

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

printf "\n\t At This Point you can umount the virtual filesystem and backup the temporary tools \n"

