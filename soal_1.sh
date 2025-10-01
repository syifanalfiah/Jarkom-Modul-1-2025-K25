auto eth1
iface eth1 inet static
    address 10.76.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.76.2.1
    netmask 255.255.255.0

auto eth0
iface eth0 inet static
    10.76.1.2
    netmask 255.255.255.0
    gateway 10.76.1.1

auto eth0
iface eth0 inet static
    address 10.76.1.3
    netmask 255.255.255.0
    gateway 10.76.1.1

auto eth0
iface eth0 inet static
    address 10.76.2.2
    netmask 255.255.255.0
    gateway 10.76.2.1

auto eth0
iface eth0 inet static
    address 10.76.2.3
    netmask 255.255.255.0
    gateway 10.76.2.1
