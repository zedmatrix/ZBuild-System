#!/bin/bash
head -n7 /proc/cpuinfo | awk '
/cpu family/ { family = $4 }
/model/ && !/name/ { model = $3 }
/stepping/ { stepping = $3 }
END { printf "%02X-%02X-%02X\n", family, model, stepping }'
