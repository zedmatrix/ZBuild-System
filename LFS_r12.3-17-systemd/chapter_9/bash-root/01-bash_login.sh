cat > ~/.bash_login << "EOF"
#!/bin/bash
# Begin ~/.bash_login

# Personal items to perform on logout.
clear
cat<<'EOF'
           _..._
         .'     '.
        /  _   _  \
        | (o)_(o) |
         \(     ) /
         //'._.'\ \
        //   .   \ \
       ||   .     \ \
       |\   :     / |
       \ `) '   (`  /_
     _)``".____,.'"` (_
     )     )'--'(     (
      '---`      `---`
'EOF'
echo "Hello $(whoami)"

echo "Current Date and Time"
echo $(date '+%A %B %d/%Y_%H:%M:%S')

# End ~/.bash_login
EOF
[ -f ~/.bash_login ] && echo " Created ~/.bash_login "

