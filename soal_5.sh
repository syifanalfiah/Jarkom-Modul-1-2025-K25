# INI ERUUUUUUU


# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
apt install -y vsftpd
apt-get install ftp
apt-get update
apt-get install vsftpd
apt-get update
apt-get install telnet -y

# INI MELKORRRRRRRR

# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

apt update && apt-get install -y \
  wget \
  vsftpd \
  netcat-traditional \
  ftp \
  telnet \
  inetutils-telnetd \
  openssh-server
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install telnetd -y
apt-get install openbsd-inetd -y


# INIIIIII MANWE

# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
echo nameserver 192.168.122.1
apt update && apt-get install -y \
  wget \
  vsftpd \
  netcat-traditional \
  ftp \
  telnet \
  inetutils-telnetd \
  openssh-server
echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get install inetutils-ftp -y

# INIIIIIIII VARDA

# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

apt update && apt-get install -y \
  wget \
  vsftpd \
  netcat-traditional \
  ftp \
  telnet \
  inetutils-telnetd \
  openssh-server
echo nameserver 192.168.122.1 > /etc/resolv.conf

# INIIIIIIIII ULMO

# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'


apt update && apt-get install -y \
  wget \
  vsftpd \
  netcat-traditional \
  ftp \
  telnet \
  inetutils-telnetd \
  openssh-server \
  ftp
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get install inetutils-ftp -y