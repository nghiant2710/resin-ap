FROM resin/rpi-raspbian:wheezy

RUN apt-get update && apt-get install -y python \ 
										dnsmasq \
										hostapd \
										iptables \
										nano \
										net-tools \
										wget

# If Wifi Adapter is Edimax, Uncomment this block
RUN wget http://www.daveconroy.com/wp3/wp-content/uploads/2013/07/hostapd.zip \
	&& unzip hostapd.zip \
	&& mv /usr/sbin/hostapd /usr/sbin/hostapd.bak \
	&& mv hostapd /usr/sbin/hostapd.edimax \
	&& ln -sf /usr/sbin/hostapd.edimax /usr/sbin/hostapd \
	&& chown root.root /usr/sbin/hostapd \
	&& chmod 755 /usr/sbin/hostapd

ENV SSID ResinAP
ENV PSK 12345678-

# Set static IP for wlan0 interface
RUN sed -i -e 's/^iface wlan0/#iface wlan0/' -e 's/^wpa-roam/#wpa-roam/' -e 's/^iface default/#iface default/' /etc/network/interfaces
RUN echo "iface wlan0 inet static" >> /etc/network/interfaces \
	&& echo "  address 192.168.42.1" >> /etc/network/interfaces \
	&& echo "  netmask 255.255.255.0" >> /etc/network/interfaces

# Add IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
# && echo 1 > /proc/sys/net/ipv4/ip_forward

# Activate the access point at startup
#RUN update-rc.d hostapd enable
RUN update-rc.d dnsmasq enable

# Set SSID and PSK

ADD . /App/
RUN mv /etc/dnsmasq.conf /etc/dnsmasq.default \
	&& cp /App/hostapd.conf /etc/hostapd/hostapd.conf \
	&& cp /App/dnsmasq.conf /etc/dnsmasq.conf \
	&& cp /App/hosts.me /etc/hosts.me

RUN sed -i -e "s/SETSSID/$SSID/" -e "s/SETPSK/$PSK/" /etc/hostapd/hostapd.conf

# Start web server
CMD ["bash", "-ex", "/App/start.sh"]