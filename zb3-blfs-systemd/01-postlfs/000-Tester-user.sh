#!/bin/bash

printf "\n\t*** Creating a Tester User ***\n\n"

groupadd -g 101 tester
useradd -g tester -u 101 -d /home/tester -s /bin/false -c "Check Tester User" tester
passwd tester

# Create home if not made automatically
[ ! -d /home/tester ] && mkdir -p /home/tester && chown tester:tester /home/tester

# Write minimal .bashrc if needed
if [[ -d /home/tester ]]; then
    bashrc=/home/tester/.bashrc

    echo "# Minimal .bashrc for tester" > "$bashrc"
    [[ -n $ZBUILD_script ]] && echo "export ZBUILD_script=\"$ZBUILD_script\"" >> "$bashrc"
    [[ -n $ZBUILD_sources ]] && echo "export ZBUILD_sources=\"$ZBUILD_sources\"" >> "$bashrc"
    [[ -n $ZBUILD_log ]] && echo "export ZBUILD_log=\"$ZBUILD_log\"" >> "$bashrc"
    [[ -n $ZBUILD_root ]] && echo "export ZBUILD_root=\"$ZBUILD_root\"" >> "$bashrc"
    [[ -n $PATH ]] && echo "export PATH=\"$PATH\"" >> "$bashrc"

    chown tester:tester "$bashrc"
fi
