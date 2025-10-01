# melkor
apt-get update
apt-get install -y apache2
service apache2 start
service apache2 status

nc -zv -w 2 10.76.1.2 21 2>&1

nc -zv -w 2 10.76.1.2 80 2>&1

nc -zv -w 2 10.76.1.2 666 2>&1