#!/bin/bash
printf "\n\t Configuring Libcap-2.75 For Linux-PAM-1.7.0 \n"

mv -v /etc/pam.d/system-auth{,.bak} &&
cat > /etc/pam.d/system-auth << "EOF" &&
# Begin /etc/pam.d/system-auth

auth      optional    pam_cap.so
EOF
tail -n +3 /etc/pam.d/system-auth.bak >> /etc/pam.d/system-auth

[ -f /etc/pam.d/system-auth ] && echo " Updating /etc/pam.d/system-auth "
