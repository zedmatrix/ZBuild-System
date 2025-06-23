#!/bin/bash
cat > /etc/rc.d/init.d/network << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides: network
# Required-Start: $local_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Starts dhcpcd for network interface(s)
### END INIT INFO

DHCPCD_BIN=/sbin/dhcpcd
IFACE=${IFACE:-eth0}  # default interface

case "$1" in
  start)
    echo "Starting network on $IFACE..."
    $DHCPCD_BIN "$IFACE"
    ;;
  stop)
    echo "Stopping dhcpcd on $IFACE..."
    $DHCPCD_BIN -x "$IFACE"
    ip link set "$IFACE" down
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    $DHCPCD_BIN -U "$IFACE"
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
EOF

chmod +x /etc/rc.d/init.d/network
ln -sv ../init.d/network /etc/rc.d/rc3.d/S10network
