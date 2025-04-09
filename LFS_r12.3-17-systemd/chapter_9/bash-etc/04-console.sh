cat > /etc/vconsole.conf << "EOF"
KEYMAP=us
#FONT=Lat2-Terminus16
FONT="lat9w-16"
EOF
[ -f /etc/vconsole.conf ] && echo " Created /etc/vconsole.conf "

cat > /etc/locale.conf << "EOF"
LANG="en_US.UTF-8"
EOF
[ -f /etc/locale.conf ] && echo " Created /etc/locale.conf "

