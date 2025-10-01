# klik kanan link/kabel antara Manwe dan Eru

cat > /home/ainur/shared/kitab_penciptaan.txt << 'KITAB'
Sebelum Awal, Akulah Ada.
Dari Pikiran-Ku yang tunggal,
Lahir Kehendak untuk Mencipta,
Dan Hampa pun mendengar.

Maka Kuciptakan para Ainur, Anak-anak dari Pikiran-Ku.
Masing-masing adalah percikan dari Nyala Api Abadi,
Membawa sebagian dari esensi-Ku, namun tidak seluruhnya.

Kuberikan kepada mereka sebuah Tema Agung,
Dan kuminta mereka merajutnya menjadi Musik yang tiada tara.

Dalam Harmoni mereka, sebuah Visi terbentang:
Dunia yang akan ada, Arda.

Namun satu di antara mereka, yang terkuat, menenun melodi sumbang dari kesombongan.
Tetapi dia tidak tahu, bahwa nada paling gelap sekalipun
Pada akhirnya hanya akan menjadi bagian dari Desain-Ku yang lebih agung.

Maka saat Visi itu utuh, Aku pun bersabda:
"EÄ! JADILAH!"
Dan Dunia pun menjadi nyata, terikat dalam Ruang dan Waktu.

Di sanalah, Anak-anak Ilúvatar akan berjalan,
Dan melalui mereka, takdir Dunia akan digenapi.

Sebab segala sesuatu berasal dari-Ku, dan akan kembali kepada-Ku.
KITAB

chown ainur:ainur /home/ainur/shared/kitab_penciptaan.txt
chmod 644 /home/ainur/shared/kitab_penciptaan.txt

cat /home/ainur/shared/kitab_penciptaan.txt

nano /etc/vsftpd.conf

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

# konfigurasi per-user
user_config_dir=/etc/vsftpd/user_conf

# tambahkan user ke userlist
echo "ainur" > /etc/vsftpd.userlist

# buat konfigurasi read-only untuk ainur
mkdir -p /etc/vsftpd/user_conf

cat > /etc/vsftpd/user_conf/ainur << EOF
write_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO
EOF

# restart vsftpd
service vsftpd restart
service vsftpd status

# login ke console Client MANWE di GNS3
apt-get update
apt-get install -y ftp

# cek koneksi ke server
ping 10.76.1.1 -c 3

cd /home

# connect ke FTP Server Eru
ftp 10.76.1.1

Name: ainur
Password: passwordainur

ftp> ls
ftp> cd shared
ftp> ls
ftp> binary              
ftp> get kitab_penciptaan.txt
ftp> quit

# cek file sudah ada
ls -lh /home/kitab_penciptaan.txt

# baca isi file
cat /home/kitab_penciptaan.txt

# connect lagi ke FTP
ftp 10.76.1.1
# login: ainur / passwordainur

ftpftp> cd shared
ftp> put /etc/hostname test_upload.txt
ftpftp> mkdir test_folder
ftpftp> delete kitab_penciptaan.txt
ftpftp> quit

# apply Display Filter:
ftp or ftp-data
# atau untuk filter berdasarkan IP Manwe:
ip.addr == 10.76.1.3 && (ftp or ftp-data)