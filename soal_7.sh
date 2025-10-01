apt-get update
apt-get install vsftpd

mkdir -p /home/shared
chmod 755 /home/shared

mkdir /home/ainur/shared
chown ainur:ainur /home/ainur/shared
chmod 755 /home/ainur/shared

# user ainur dengan hak akses write & read
useradd -m -d /home/ainur -s /bin/bash ainur
echo "ainur:passwordainur" | chpasswd

# user melkor tanpa hak akses
useradd -m -d /home/melkor -s /bin/bash melkor
echo "melkor:passwordmelkor" | chpasswd

nano /etc/vsftpd.conf

# isi file 
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES

chroot_local_user=YES
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd

userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100

echo "ainur" > /etc/vsftpd.userlist
echo "melkor" >> /etc/vsftpd.userlist

chown -R ainur:ainur /home/shared
chmod 755 /home/shared

chmod 700 /home/shared
chown ainur:ainur /home/shared


service vsftpd start
service vsftpd status
service vsftpd restart

#test client lain
apt-get update
apt-get install inetutils-ftp -y

#user ainur
ftp 10.76.1.1

ls                 
cd shared            
get test.txt        
put newfile.txt    
quit


#user melkor
ftp 10.76.1.1

ls               
cd /home/shared   
quit