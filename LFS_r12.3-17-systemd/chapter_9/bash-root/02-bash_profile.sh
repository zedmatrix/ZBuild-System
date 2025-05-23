cat > ~/.bash_profile << "EOF"
#!/bin/bash
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.

# System wide environment variables and startup programs are in /etc/profile.

# System wide aliases and functions are in /etc/bashrc.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

# End ~/.bash_profile
EOF
[ -f ~/.bash_profile ] && echo " Created ~/.bash_profile "

