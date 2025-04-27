#!/bin/bash
if [ -z $1 ]; then 
	echo " Not Adding a Username "
else
	newuser=$1
	echo " Creating user: $newuser "
fi

printf " \n\t *** Adding a User Configuration *** \n "
[ ! -d /etc/skel ] && mkdir -v /etc/skel

[ -f /etc/inputrc ] && cp -v /etc/inputrc /etc/skel/.inputrc

[ -f /etc/bash_profile ] && cp -v /etc/bash_profile /etc/skel/.bash_profile

[ -f /etc/bashrc ] && cp -v /etc/bashrc /etc/skel/.bashrc

[ -f /etc/vimrc ] && cp -v /etc/vimrc /etc/skel/.vimrc

[ -f /etc/nanorc ] && cp -v /etc/nanorc /etc/skel/.nanorc

[ -f /etc/dircolors ] && cp -v /etc/dircolors /etc/skel/.dircolors

if [ -n $newuser ]; then
	printf " Now you can add a user \n "
	useradd -m $newuser
fi
if [ -n $newuser ]; then
	printf " Update new user's passwd \n "
	passwd $newuser
fi
printf " \n\t *** Finished *** \n "
