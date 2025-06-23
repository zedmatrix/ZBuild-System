#!/bin/bash
cat > /etc/rc.d/init.d/sshd << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides: sshd
# Required-Start: $network $remote_fs
# Required-Stop: $network $remote_fs
# Default-Start: 3 4 5
# Default-Stop: 0 1 6
# Short-Description: OpenSSH server daemon
# Description: Starts and stops the OpenSSH server daemon.
### END INIT INFO

SSHD_BIN=/usr/sbin/sshd
SSHD_PIDFILE=/var/run/sshd.pid
SSHD_CONFIG=/etc/ssh/sshd_config

case "$1" in
  start)
    echo "Starting sshd..."
    if [ -x "$SSHD_BIN" ]; then
      if [ ! -f "$SSHD_CONFIG" ]; then
        echo "sshd_config not found at $SSHD_CONFIG"
        exit 1
      fi
      "$SSHD_BIN"
    else
      echo "sshd binary not found!"
      exit 1
    fi
    ;;
  stop)
    echo "Stopping sshd..."
    if [ -f "$SSHD_PIDFILE" ]; then
      kill "$(cat "$SSHD_PIDFILE")" && rm -f "$SSHD_PIDFILE"
    else
      # Fallback: kill by name
      killall sshd 2>/dev/null
    fi
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    if pgrep -x sshd >/dev/null; then
      echo "sshd is running"
    else
      echo "sshd is not running"
      exit 1
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
EOF

chmod -v +x /etc/rc.d/init.d/sshd

ln -sv ../init.d/sshd /etc/rc.d/rc3.d/S30sshd
