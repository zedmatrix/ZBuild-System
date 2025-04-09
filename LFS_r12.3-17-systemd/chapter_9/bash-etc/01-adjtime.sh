cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF
[ -f /etc/adjtime ] && echo " Created /etc/adjtime "

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF
[ -f /etc/shells ] && echo " Created /etc/shells "
