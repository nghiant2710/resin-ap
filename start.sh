#!/bin/bash

# Set SSID and PSK
sed -i -e "s/SETSSID/$SSID/" -e "s/SETPSK/$PSK/" /etc/hostapd/hostapd.conf

# Enable NAT
ifdown wlan0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE \
	&& iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT \
	&& iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT \
	&& iptables -t nat -I PREROUTING -p udp --dport 53 -j DNAT --to-destination 192.168.42.1:5353 \
	&& iptables -t nat -I PREROUTING -p tcp --dport 53 -j DNAT --to-destination 192.168.42.1:5353
# Forward all dns traffic from port 53 to 5353

# Restart DNSMASQ service
ifup wlan0
/etc/init.d/dnsmasq restart
sleep 1m

# Start AP and webserver
hostapd -dd -B /etc/hostapd/hostapd.conf
python /App/server.py & tail -f /var/log/dnsmasq.log