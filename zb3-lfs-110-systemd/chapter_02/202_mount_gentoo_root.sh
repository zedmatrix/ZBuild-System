gentoo=/mnt/gentoo
chroot $gentoo /usr/bin/env -i HOME=/root TERM="$TERM" \
    PS1="(Gentoo chroot) ${PS1}" \
    PATH=/usr/bin:/usr/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
