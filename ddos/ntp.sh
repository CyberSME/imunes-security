#!/bin/sh

# enable MONLIST in ntp.conf and start the ntpd on n# nodes
for x in $(seq 1 16); do 
    sudo himage n$x  sed -i"" -e "$ a \\
enable monitor" /etc/ntp.conf
    sudo himage n$x service ntpd onestart
done

# copy the scapy script to the attacker
sudo hcp ntp.scapy Attacker:

# start capture of the attack packets
sudo himage Attacker tcpdump -ni eth0 -c 16 port 123 &
# start the scapy script that crafts the attack packets
sudo himage Attacker scapy -c ntp.scapy
