#!/bin/bash
printf " \n\t ** Configuring Sudo-1.9.16p2 ** \n "
cat > /etc/sudoers.d/00-sudo << "EOF"
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) ALL
EOF

printf " \n\t ** Configuring Sudo for Linux-PAM ** \n "
cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
[ -f /etc/pam.d/sudo ] && echo " Created: /etc/pam.d/sudo "
chmod -v 644 /etc/pam.d/sudo

printf " \n\t ** Finished ** \n "

