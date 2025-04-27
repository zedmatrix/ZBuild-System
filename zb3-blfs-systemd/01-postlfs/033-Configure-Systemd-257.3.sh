#!/bin/bash
printf " \n\t Configuring Systemd-257.3 for Linux-PAM-1.7.0 \n"

grep 'pam_systemd' /etc/pam.d/system-session ||
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition

session  required    pam_loginuid.so
session  optional    pam_systemd.so

# End Systemd addition
EOF
[ -f /etc/pam.d/system-session ] && echo " Updating /etc/pam.d/system-session "

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/systemd-user
EOF
[ -f /etc/pam.d/systemd-user ] && echo " Created /etc/pam.d/systemd-user "

printf "\n\t Reload systemd manager \n"
systemctl daemon-reexec

printf "\n\t Then Log Out and Log In to make sure systemd-logind is running \n"

