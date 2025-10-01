apt-get update
apt-get install inetutils-ftp -y # kalau gagal ftp -y aja

# link ke kabel swicth ke ulmo

ftp 10.76.1.1

Name: ainur
Password: passwordainur

cd shared

put cuaca.txt

ls

quit

# filter wireshark

ftp

# mencari Perintah STOR (Upload):
ftp.request.command == "STOR"

# melihat Semua Perintah FTP:
ftp.request.command