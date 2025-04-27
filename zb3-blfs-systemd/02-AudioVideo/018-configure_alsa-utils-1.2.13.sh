printf "\n\t Configuring ALSA \n"
alsactl init

alsactl -L store

printf "\n\t You May need /etc/asound.conf \n"
cat > /etc/asound.conf << "EOF"
# Begin /etc/asound.conf

defaults.pcm.card 0
defaults.ctl.card 0

# End /etc/asound.conf
EOF
[ -f /etc/asound.conf ] && echo " Created /etc/asound.conf "

