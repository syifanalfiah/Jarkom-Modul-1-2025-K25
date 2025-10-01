
apt-get update
apt-get install -y telnetd xinetd inetutils-telnetd

# buat file /etc/xinetd.conf (utama)
cat > /etc/xinetd.conf << 'EOF'
defaults
{
    instances       = 60
    log_type        = SYSLOG authpriv
    log_on_success  = HOST PID
    log_on_failure  = HOST
    cps             = 25 30
}
includedir /etc/xinetd.d
EOF

# konfigurasi service telnet di xinetd
cat > /etc/xinetd.d/telnet << 'EOF'
service telnet
{
    disable         = no
    flags           = REUSE
    socket_type     = stream
    wait            = no
    user            = root
    server          = /usr/sbin/in.telnetd
    log_on_failure  += USERID
}
EOF

# tambah user untuk testing
useradd -m -d /home/erutest -s /bin/bash erutest
echo "erutest:passworderu123" | chpasswd

useradd -m -d /home/secretuser -s /bin/bash secretuser
echo "secretuser:mysecretpass" | chpasswd

nano /etc/xinetd.d/telnet

apt-get purge -y xinetd
apt-get install -y openbsd-inetd telnetd

service openbsd-inetd restart
service openbsd-inetd status

nano /etc/inetd.conf

# isinya
telnet  stream  tcp     nowait  root    /usr/sbin/telnetd  telnetd

service telnet
{
    disable         = no
    flags           = REUSE
    socket_type     = stream
    wait            = no
    user            = root
    server          = /usr/sbin/telnetd
    log_on_failure  += USERID
}


# start & cek service
service xinetd restart
service xinetd status

# verifikasi port 23 listening
ss -tuln | grep :23

# node eru

apt-get update
apt-get install -y telnet

which telnet

# test koneksi
ping -c 4 10.76.1.2

# coba telnet
telnet 10.76.1.2
# login: erutest / passworderu123

# Di GNS3:
# - Klik kanan link Eru <-> Switch
# - Start Capture
# - Wireshark terbuka otomatis


# Filter:
telnet
