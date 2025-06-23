#!/bin/bash
cat > /etc/rc.d/init.d/halt << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides: halt
# Required-Start:
# Default-Stop: 0
# Short-Description: Halts the system
### END INIT INFO

case "$1" in
  start)
    echo "System is halting..."
    exec /sbin/poweroff -f
    ;;
  *)
    echo "Usage: $0 start"
    exit 1
esac
EOF

cat > /etc/rc.d/init.d/reboot << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides: reboot
# Required-Start:
# Default-Stop: 6
# Short-Description: Reboots the system
### END INIT INFO

case "$1" in
  start)
    echo "System is rebooting..."
    exec /sbin/reboot -f
    ;;
  *)
    echo "Usage: $0 start"
    exit 1
esac
EOF

ln -sv ../init.d/halt /etc/rc.d/rc0.d/S90halt
ln -sv ../init.d/reboot /etc/rc.d/rc6.d/S90reboot
