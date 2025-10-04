| Nama                        | NRP        |
| --------------------------- | ---------- |
| Syifa Nurul Alfiah          | 5027241019 |

**IP Addressing:**
- Eru: 10.76.1.1 (eth1), 10.76.2.1 (eth2)
- Melkor: 10.76.1.2
- Manwe: 10.76.1.3
- Varda: 10.76.2.2
- Ulmo: 10.76.2.3

---

## 1. Konfigurasi Static IP (soal_1.sh)
<img width="988" height="748" alt="image" src="https://github.com/user-attachments/assets/32db62ad-df7d-4230-97f2-0196d4c7703f" />


### Router Eru
```bash
auto eth1
iface eth1 inet static
    address 10.76.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.76.2.1
    netmask 255.255.255.0
```

### Client Nodes
Setiap client dikonfigurasi dengan IP static dan gateway menuju Eru:

**Melkor (10.76.1.2):**
```bash
auto eth0
iface eth0 inet static
    address 10.76.1.2
    netmask 255.255.255.0
    gateway 10.76.1.1
```

**Manwe (10.76.1.3):**
```bash
auto eth0
iface eth0 inet static
    address 10.76.1.3
    netmask 255.255.255.0
    gateway 10.76.1.1
```

Lakukan hal yang sama untuk Varda (10.76.2.2) dan Ulmo (10.76.2.3) dengan gateway 10.76.2.1.

### Testing
```bash
ping 10.76.1.1  # dari client ke router
ping 10.76.1.3  # antar client
```

---

## 2. Internet Gateway untuk Router (soal_2.sh)

Eru perlu akses internet menggunakan DHCP:

```bash
auto eth0
iface eth0 inet dhcp
```

Restart network:
```bash
service networking restart
ping google.com
```

---

## 3. NAT untuk Koneksi Antar Client (soal_3.sh)

### Di Router Eru
Aktifkan IP forwarding dan NAT:

```bash
# Enable NAT/Masquerade
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
```

Tambahkan di konfigurasi network Eru:
```bash
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
```

### Di Setiap Client
Set DNS resolver:
```bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### Testing
```bash
ping 10.76.2.2  # dari Melkor ke Varda (beda subnet)
ping 10.76.1.3  # dari Ulmo ke Manwe
```

---

## 4. Internet Access untuk Client (soal_4.sh)

Dengan NAT yang sudah dikonfigurasi di soal 3, sekarang test internet access:

```bash
# Di setiap client
ping google.com
ping 8.8.8.8
```

Jika gagal, pastikan:
- NAT sudah aktif di Eru
- DNS resolver sudah di-set
- Routing table benar

```bash
route -n  # check routing table
```

---

## 5. Persistent Configuration (soal_5.sh)

Agar konfigurasi tidak hilang saat restart, tambahkan command ke `.bashrc` atau buat startup script.

### Eru
```bash
# Add to /root/.bashrc
apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.76.0.0/16
apt install -y vsftpd telnet
```

### Melkor
```bash
apt update && apt-get install -y \
  wget vsftpd netcat-traditional ftp telnet \
  inetutils-telnetd openssh-server openbsd-inetd telnetd
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### Manwe, Varda, Ulmo
Install dependencies yang diperlukan:
```bash
apt update && apt-get install -y \
  wget vsftpd netcat-traditional ftp telnet \
  inetutils-telnetd openssh-server inetutils-ftp
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

---

## 6. Packet Sniffing dengan Wireshark (soal_6.sh)

Melkor mencoba sniffing komunikasi Manwe-Eru.

### Setup
1. Jalankan traffic script (jika ada)
```bash
chmod +x traffic.sh
./traffic.sh
```

2. Di GNS3:
   - Klik kanan pada link antara Switch1 dan Manwe
   - Pilih "Start Capture"
   - Wireshark otomatis terbuka

3. Generate traffic dari Manwe:
```bash
ping 10.76.1.1 -c 10
```

4. Apply display filter di Wireshark:
```
ip.addr == 10.76.1.3
```

5. Save capture sebagai `.pcapng`

---

## 7. FTP Server Setup (soal_7.sh)

### Install & Configure FTP Server di Eru

```bash
apt-get update
apt-get install vsftpd

# Buat shared directory
mkdir -p /home/shared
chmod 755 /home/shared
```
![photo_6271744518637947943_y](https://github.com/user-attachments/assets/c9d9cc3d-8b7b-454c-86b6-36fc33e5ad5c)


### Buat User dengan Hak Akses Berbeda

**User ainur (read & write access):**
```bash
useradd -m -d /home/ainur -s /bin/bash ainur
echo "ainur:passwordainur" | chpasswd
mkdir /home/ainur/shared
chown ainur:ainur /home/ainur/shared
chmod 755 /home/ainur/shared
```

**User melkor (no access):**
```bash
useradd -m -d /home/melkor -s /bin/bash melkor
echo "melkor:passwordmelkor" | chpasswd
```

### Konfigurasi vsftpd

Edit `/etc/vsftpd.conf`:
```ini
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
```

### Setup User Access List
```bash
echo "ainur" > /etc/vsftpd.userlist
echo "melkor" >> /etc/vsftpd.userlist

chown -R ainur:ainur /home/shared
chmod 755 /home/shared

service vsftpd restart
```

### Testing dari Client

**Install FTP client:**
```bash
apt-get update
apt-get install inetutils-ftp -y
```

**Test user ainur (should work):**
```bash
ftp 10.76.1.1
# Login: ainur / passwordainur

ftp> ls
ftp> cd shared
ftp> put test.txt
ftp> get test.txt
ftp> quit
```

**Test user melkor (should fail):**
```bash
ftp 10.76.1.1
# Login: melkor / passwordmelkor

ftp> ls             
ftp> cd /home/shared 
ftp> quit
```



---

## 8. FTP Upload dari Ulmo (soal_8.sh)

### Setup FTP Client di Ulmo
```bash
apt-get update
apt-get install inetutils-ftp -y
```

### Upload File cuaca.txt

1. Start Wireshark capture di link Switch2 → Ulmo

2. Connect ke FTP:
```bash
ftp 10.76.1.1
# Name: ainur
# Password: passwordainur

ftp> cd shared
ftp> put cuaca.txt
ftp> ls
ftp> quit
```

### Analisis Wireshark

**Display filter:**
```
ftp
```

**Mencari perintah upload:**
```
ftp.request.command == "STOR"
```

**Melihat semua command FTP:**
```
ftp.request.command
```

**Hasil yang diharapkan:**
- `USER ainur`
- `PASS passwordainur`
- `CWD shared`
- `STOR cuaca.txt` ← Perintah upload
- `226 Transfer complete`

![photo_6271744518637947943_y](https://github.com/user-attachments/assets/4b8179b2-b3d0-40d2-b172-3e099f68976b)

---

## 9. FTP Download & Read-Only User (soal_9.sh)

### Buat File Kitab Penciptaan di Eru

```bash
cat > /home/ainur/shared/kitab_penciptaan.txt << 'KITAB'
Sebelum Awal, Akulah Ada.
Dari Pikiran-Ku yang tunggal,
Lahir Kehendak untuk Mencipta,
Dan Hampa pun mendengar.

Maka Kuciptakan para Ainur, Anak-anak dari Pikiran-Ku.
Masing-masing adalah percikan dari Nyala Api Abadi,
Membawa sebagian dari esensi-Ku, namun tidak seluruhnya.
...
KITAB

chown ainur:ainur /home/ainur/shared/kitab_penciptaan.txt
chmod 644 /home/ainur/shared/kitab_penciptaan.txt
```

### Ubah User ainur Menjadi Read-Only

Buat konfigurasi per-user:
```bash
mkdir -p /etc/vsftpd/user_conf

cat > /etc/vsftpd/user_conf/ainur << EOF
write_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO
EOF
```

Tambahkan ke `/etc/vsftpd.conf`:
```ini
user_config_dir=/etc/vsftpd/user_conf
```

Restart service:
```bash
service vsftpd restart
```

### Download dari Manwe

1. Start Wireshark capture di link Eru ↔ Manwe

2. Download file:
```bash
# Di Manwe
cd /home
ftp 10.76.1.1
# Login: ainur / passwordainur

ftp> cd shared
ftp> ls
ftp> binary
ftp> get kitab_penciptaan.txt
ftp> quit

cat /home/kitab_penciptaan.txt
```

3. Test read-only access:
```bash
ftp 10.76.1.1
# Login: ainur / passwordainur

ftp> cd shared
ftp> put /etc/hostname test_upload.txt 
ftp> mkdir test_folder                 
ftp> delete kitab_penciptaan.txt        
ftp> quit
```

### Analisis Wireshark

**Filter:**
```
ftp or ftp-data
ip.addr == 10.76.1.3 && (ftp or ftp-data)
```

**Perintah yang terlihat:**
- `RETR kitab_penciptaan.txt` ← Download command
- `550 Permission denied` ← Saat coba upload/delete

---

## 10. Ping Flooding Attack (soal_10.sh)

Melkor melakukan DoS attack dengan ping flooding.

### Normal Ping (Baseline)
```bash
# Di Melkor
ping 10.76.1.1 -c 5
```

Output normal:
```
5 packets transmitted, 5 received, 0% packet loss
rtt min/avg/max/mdev = 0.089/0.123/0.156/0.024 ms
```

### Ping Flooding (100 paket)
```bash
ping 10.76.1.1 -c 100 -i 0.01
```

### Ping Flooding Ekstrem (1000 paket)
```bash
ping 10.76.1.1 -c 1000 -i 0.001
```

### Monitoring di Eru

**Monitor dengan tcpdump:**
```bash
tcpdump -i eth0 icmp -n
```

**Check CPU usage:**
```bash
top
```

**Network statistics:**
```bash
netstat -s | grep -i icmp
```

### Wireshark Analysis

1. Start capture di link Melkor → Switch1
2. Jalankan ping flooding
3. Apply filter:
```
icmp
ip.addr == 10.76.1.2 && icmp
```

### Hasil yang Dicatat

| Jenis Ping | Jumlah Paket | Packet Loss | Avg RTT |
|------------|--------------|-------------|---------|
| Normal     | 5            | 0%          | 0.12 ms |
| Flooding   | 100          | 2%          | 1.23 ms |
| Ekstrem    | 1000         | 5%          | 2.45 ms |

**Dampak serangan:**
- Peningkatan latency (RTT naik signifikan)
- Packet loss mulai terjadi
- CPU server meningkat
- Bandwidth terpakai untuk ICMP traffic

---

## 11. Telnet Security Weakness (soal_11.sh)

Membuktikan bahwa Telnet mengirim credentials dalam plaintext.

### Setup Telnet Server di Melkor

```bash
apt-get update
apt-get install -y telnetd xinetd inetutils-telnetd openbsd-inetd

# Konfigurasi xinetd
cat > /etc/xinetd.d/telnet << 'EOF'
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
EOF

service xinetd restart
```

**Atau menggunakan inetd:**
```bash
# Edit /etc/inetd.conf
telnet  stream  tcp  nowait  root  /usr/sbin/telnetd  telnetd

service openbsd-inetd restart
```

### Buat Test User
```bash
useradd -m -d /home/erutest -s /bin/bash erutest
echo "erutest:passworderu123" | chpasswd

useradd -m -d /home/secretuser -s /bin/bash secretuser
echo "secretuser:mysecretpass" | chpasswd
```

### Verifikasi Service
```bash
ss -tuln | grep :23
```

### Koneksi Telnet dari Eru

1. Install telnet client:
```bash
apt-get install -y telnet
```

2. Start Wireshark capture di link Eru → Switch1

3. Connect via Telnet:
```bash
telnet 10.76.1.2
# Login: erutest
# Password: passworderu123
```

### Analisis Wireshark

**Filter:**
```
telnet
tcp.port == 23
```

**Yang terlihat:**
- Username dan password dikirim dalam plaintext
- Setiap keystroke terlihat jelas
- Tidak ada enkripsi sama sekali

**Bukti kelemahan:** Buka packet detail → Follow TCP Stream, username dan password terlihat jelas.

---

## 12. Port Scanning dengan Netcat (soal_12.sh)

Eru melakukan port scanning untuk mendeteksi service di Melkor.

### Setup Service di Melkor

```bash
# Install Apache untuk port 80
apt-get update
apt-get install -y apache2
service apache2 start
```

### Port Scanning dari Eru

**Scan port 21 (FTP):**
```bash
nc -zv -w 2 10.76.1.2 21
```

**Scan port 80 (HTTP):**
```bash
nc -zv -w 2 10.76.1.2 80
```

**Scan port 666 (closed):**
```bash
nc -zv -w 2 10.76.1.2 666
```

### Expected Output

```
10.76.1.2 21 (ftp) open
10.76.1.2 80 (http) open
10.76.1.2 666 : Connection refused
```

**Parameter netcat:**
- `-z`: Zero-I/O mode (scanning)
- `-v`: Verbose output
- `-w 2`: Timeout 2 detik

---

## 13. SSH vs Telnet Security (soal_13.sh)

Membandingkan keamanan SSH dengan Telnet.

### Setup SSH Server di Eru

```bash
apt-get update
apt-get install -y openssh-server
service ssh start
ss -tuln | grep :22
```

### SSH Connection dari Varda

```bash
# Install SSH client
apt-get update
apt-get install -y openssh-client

# Connect via SSH
ssh erutest@10.76.1.1
```

### Wireshark Capture

1. Start capture di link Varda → Switch2
2. Lakukan koneksi SSH
3. Apply filter:
```
tcp.port == 22
ip.addr == 10.76.2.2 && tcp.port == 22
```

### Analisis Hasil

**Perbedaan dengan Telnet:**
- Semua data terenkripsi
- Username dan password tidak terlihat
- Hanya terlihat encrypted payload
- Menggunakan TLS/SSL handshake

**Follow TCP Stream:** Data tidak terbaca (encrypted).

**Kesimpulan:** SSH menggunakan enkripsi end-to-end, membuat credentials dan data aman dari sniffing.

---

## 14. Brute Force Attack Analysis (soal_14.sh)


### Download Capture File

```bash
nc 10.15.43.32 3401 > brute_force.pcap
```

### Analisis dengan Wireshark

**Filter untuk mencari login sukses:**
```
http contains "success" || http contains "welcome" || http contains "dashboard"
```

**Filter spesifik:**
```
http contains "success"
```

### Identifikasi Brute Force

Cari pattern:
- Banyak request login dengan kredensial berbeda
- Response 401 Unauthorized berulang
- Satu request dengan response 200 OK

### Flag
```
KOMJAR25{Brut3_F0rc3_f6xnt83gDVzUyJryp82HCrMwY}
```

---

## 15. USB Keylogger Analysis (soal_16.sh)


### Analisis Keystrokes

Dari soal_16.sh:
```
ind@psg420.com:{6r_6e#TfT1p
```

### Hash Analysis

File berisi 5 hash SHA-256:
```
ca34b0926cdc3242bbfad1c4a0b42cc2750d90db9a272d92cfb6cb7034d2a3bd
08eb941447078ef2c6ad8d91bb2f52256c09657ecd3d5344023edccf7291e9fc
32e1b3732cd779af1bf7730d0ec8a7a87a084319f6a0870dc7362a15ddbd3199
4ebd58007ee933a0a8348aee2922904a7110b7fb6a316b1c7fb2c6677e613884
10ce4b79180a2ddd924fdc95951d968191af2ee3b7dfc96dd6a5714dbeae613a
```

### Flag
```
KOMJAR25{Y0u_4r3_4_g00d_4nalyz3r_jLeM4A0PhTSH66yec4SlMYPxg}
```

---

## 16. Malware File Identification (soal_17.sh)

### Download Capture

```bash
nc 10.15.43.32 3404 > malware_capture.pcap
```

### Filter untuk File Download

**Mencari file executable:**
```
http.request.uri contains ".doc" || http.request.uri contains ".pdf" || http.request.uri contains ".xls"
```

**Filter executable & script:**
```
http.request.uri matches "\\.(exe|dll|bat|ps1|zip|doc|docx|pdf|vbs|sh|py)$"
```

### Extract File dari Capture

**Menggunakan tshark:**
```bash
tshark -r MelkorPlan2.pcap --export-objects http,all_files
ls -la all_files/
```

### Identifikasi File Malware

```bash
sha256sum knr.exe
```

**File yang ditemukan:** `knr.exe` (executable berbahaya)

### Flag
```
KOMJAR25{M4ster_4n4lyzer_S9aSEQGXUAW8PIgLx62mAFdDi}
```
