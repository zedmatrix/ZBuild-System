printf "\n\t *** Appending /etc/profile.d/extrapaths.sh *** \n"

cat >> /etc/profile.d/extrapaths.sh << "EOF"
# Begin /rustc.sh Path Addition

pathprepend /opt/rustc/bin           PATH

# End /rustc.sh Path Addition
EOF
echo "Now You Can: source /etc/profile.d/extrapaths.sh "
