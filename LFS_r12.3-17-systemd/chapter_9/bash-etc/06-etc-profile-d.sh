mkdir -pv /etc/profile.d
cat > /etc/profile.d/dircolors.sh << "EOF"
#!/bin/bash
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi
EOF
[ -f /etc/profile.d/dircolors.sh ] && echo " Created /etc/profile.d/dircolors.sh "

cat > /etc/profile.d/extrapaths.sh << "EOF"
#!/bin/bash
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

if [ -d /usr/local/share ]; then
        pathprepend /usr/local/share XDG_DATA_DIRS
fi

# Set some defaults before other applications add to these paths.
pathappend /usr/share/info INFOPATH

EOF
[ -f /etc/profile.d/extrapaths.sh ] && echo " Created /etc/profile.d/extrapaths.sh "

cat > /etc/profile.d/i18.sh << "EOF"
#!/bin/bash
# Set up i18n variables
for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi
EOF
[ -f /etc/profile.d/i18.sh ] && echo " Created /etc/profile.d/i18.sh "

cat > /etc/profile.d/readline.sh << "EOF"
#!/bin/bash
# Set up the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF
[ -f /etc/profile.d/readline.sh ] && echo " Created /etc/profile.d/readline.sh "

cat > /etc/profile.d/umask.sh << "EOF"
#!/bin/bash
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF
[ -f /etc/profile.d/umask.sh ] && echo " Created /etc/profile.d/umask.sh "

