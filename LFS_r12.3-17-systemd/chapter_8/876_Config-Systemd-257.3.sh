printf "\n\t Configuring Systemd-257.3 \n "

tar -xf /sources/systemd-man-pages-257.3.tar.xz --no-same-owner --strip-components=1 -C /usr/share/man

systemd-machine-id-setup

systemctl preset-all

printf "\n\t Done \n"
