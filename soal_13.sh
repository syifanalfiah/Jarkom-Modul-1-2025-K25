# di varda

apt-get update
apt-get install -y openssh-client

# eru

apt-get update
apt-get install -y openssh-server
service ssh start
ss -tuln | grep :22

# varda lagi

ssh erutest@10.76.1.1

# GNS3: klik kanan kabel/link yang menghubungkan Varda

tcp.port == 22

ip.addr == 10.76.2.2 && tcp.port == 22
