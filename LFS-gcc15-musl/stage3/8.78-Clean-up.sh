#!/bin/bash
echo -e "Cleaning Up Temporary Directory"
rm -vrf /tmp/{*,.*}

echo -e "User tester is no longer needed"
userdel -r tester

echo -e "Remove the Temporary Tools From Chapter 6/7"
find /usr -depth -name $(uname -m)-lfs-linux-musl\* | xargs rm -vrf

echo "sysv-musl-lfs" > /etc/hostname
