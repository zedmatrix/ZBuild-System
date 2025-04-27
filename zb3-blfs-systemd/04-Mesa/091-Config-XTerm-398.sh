printf "\n\t Configuring XTerm-398 \n"
cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF
[ -f /etc/X11/app-defaults/XTerm ] && echo "Updated /etc/X11/app-defaults/XTerm"

cat >> ~/.Xdefaults << "EOF"
XTerm*Background: black
XTerm*Foreground: white
EOF
[ -f ~/.Xdefaults ] && echo "Created ~/.Xdefaults"
