resin-AP
=========

Resin container that turns your Raspberry Pi into an access point with DHCP and DNS server

## Environment Variables

* `SSID`
	* The SSID of your access point
	* Default: `ResinAP`
* `PSK`
	* The Passphrase of your access point. It must be at least 8 characters.
	* Default: `12345678-`

## Setup & Deployment

* Configuration for access point: hostapd.conf.
* Configuration for DHCP and DNS server: dnamasq.conf.
* Host file for DNS server: hosts.me.
* This container is hosting a python webserver. Visit helloresin.io
* For non-Edimax wifi dongles: just clone the repo and push to your resin app.
* For Edimax wifi dongles: Edit the Dockerfile to install correct hostapd for Edimax and push to your resin app.

### Notice: Hostapd is very sensitive so if you are using windows to create its configuration file, you must convert it to UNIX format. Otherwise hostapd will not work properly.