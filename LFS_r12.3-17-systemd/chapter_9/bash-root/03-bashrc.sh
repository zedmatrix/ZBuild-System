cat > ~/.bashrc << "EOF"
#!/bin/bash
# Begin ~/.bashrc

# Personal aliases and functions.

# Personal environment variables and startup programs should go in ~/.bash_profile.
# System wide environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

# Set up user specific i18n variables
export LANG=en_US.UTF-8

# End ~/.bashrc
EOF
[ -f ~/.bashrc ] && echo " Created ~/.bashrc "

