printf "\n\t Final Clean Up \n"
rm -rf /tmp/{*,.*}

find /usr/lib /usr/libexec -name \*.la -delete && echo " Removed Libtool Archive Files "

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -vrf

userdel -r tester && echo " Removed user tester "
printf "\n\t Done \n"

