#!/bin/bash
printf " \n\t *** Configuring Shadow-4.17.3 For Linux-PAM-1.7.0 *** \n "
install -v -m644 /etc/login.defs /etc/login.defs.orig &&
for FUNCTION in FAIL_DELAY FAILLOG_ENAB LASTLOG_ENAB MAIL_CHECK_ENAB OBSCURE_CHECKS_ENAB \
                PORTTIME_CHECKS_ENAB QUOTAS_ENAB CONSOLE MOTD_FILE FTMP_FILE NOLOGINS_FILE \
                ENV_HZ PASS_MIN_LEN SU_WHEEL_ONLY PASS_CHANGE_TRIES PASS_ALWAYS_WARN \
                CHFN_AUTH ENCRYPT_METHOD ENVIRON_FILE
do
    sed -i "s/^${FUNCTION}/# &/" /etc/login.defs && echo " Patching ${FUNCTION} "
done

cat > /etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login

# Set failure delay before next prompt to 3 seconds
auth      optional    pam_faildelay.so  delay=3000000

# Check to make sure that the user is allowed to login
auth      requisite   pam_nologin.so

# Check to make sure that root is allowed to login
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth      required    pam_securetty.so

# Additional group memberships - disabled by default
#auth      optional    pam_group.so

# include system auth settings
auth      include     system-auth

# check access for the user
account   required    pam_access.so

# include system account settings
account   include     system-account

# Set default environment variables for the user
session   required    pam_env.so

# Set resource limits for the user
session   required    pam_limits.so

# Display the message of the day - Disabled by default
#session   optional    pam_motd.so

# Check user's mail - Disabled by default
#session   optional    pam_mail.so      standard quiet

# include system session and password settings
session   include     system-session
password  include     system-password

# End /etc/pam.d/login
EOF
[ -f /etc/pam.d/login ] && echo " Created /etc/pam.d/login "

cat > /etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd

password  include     system-password

# End /etc/pam.d/passwd
EOF
[ -f /etc/pam.d/passwd ] && echo " Created /etc/pam.d/passwd "

cat > /etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su

# always allow root
auth      sufficient  pam_rootok.so

# Allow users in the wheel group to execute su without a password
# disabled by default
#auth      sufficient  pam_wheel.so trust use_uid

# include system auth settings
auth      include     system-auth

# limit su to users in the wheel group
# disabled by default
#auth      required    pam_wheel.so use_uid

# include system account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session settings
session   include     system-session

# End /etc/pam.d/su
EOF
[ -f /etc/pam.d/su ] && echo " Created /etc/pam.d/su "

cat > /etc/pam.d/chpasswd << "EOF"
# Begin /etc/pam.d/chpasswd

# always allow root
auth      sufficient  pam_rootok.so

# include system auth and account settings
auth      include     system-auth
account   include     system-account
password  include     system-password

# End /etc/pam.d/chpasswd
EOF
[ -f /etc/pam.d/chpasswd ] && echo " Created /etc/pam.d/chpasswd "

sed -e s/chpasswd/newusers/ /etc/pam.d/chpasswd >/etc/pam.d/newusers
[ -f /etc/pam.d/newusers ] && echo " Created /etc/pam.d/newusers "

cat > /etc/pam.d/chage << "EOF"
# Begin /etc/pam.d/chage

# always allow root
auth      sufficient  pam_rootok.so

# include system auth and account settings
auth      include     system-auth
account   include     system-account

# End /etc/pam.d/chage
EOF
[ -f /etc/pam.d/chage ] && echo " Created /etc/pam.d/chage "

for PROGRAM in chfn chgpasswd chsh groupadd groupdel \
               groupmems groupmod useradd userdel usermod
do
    install -v -m644 /etc/pam.d/chage /etc/pam.d/${PROGRAM}
    sed -i "s/chage/$PROGRAM/" /etc/pam.d/${PROGRAM}
done

printf "\n\t *** At This Point Test Shadow with Linux-PAM By Opening Another Terminal and Login as root ***\n"
if [ -f /etc/login.access ]; then mv -v /etc/login.access{,.NOUSE}; fi
if [ -f /etc/limits ]; then mv -v /etc/limits{,.NOUSE}; fi

printf " \n\t *** Finished *** \n"
