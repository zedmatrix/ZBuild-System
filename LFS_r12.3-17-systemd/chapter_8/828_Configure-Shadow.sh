printf "\n\t Configuring Shadow \n"
pwconv
grpconv
mkdir -p /etc/default
useradd -D --gid 999
sed -i '/MAIL/s/yes/no/' /etc/default/useradd && echo " Patch Out mailbox file "
printf " \n\t Enter Root Password Now: \n "
passwd root

