cat > ~/.profile << "EOF"
#!/bin/bash
# Begin ~/.profile
# Personal environment variables and startup programs.

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Set up user specific i18n variables
export LANG=en_US.UTF-8

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# End ~/.profile
EOF
[ -f ~/.profile ] && echo " Created ~/.profile "
