#!/bin/bash

# This script soft reset the CAP and format the HHD

if [ "$(id -u)" != 0 ]; then
   >&2 echo "Error: this script must be run as root."
   exit 13  # EACCES
fi



# Erase the current configuration with a backup
cd / && tar xvf /etc/factory-config.tgz

# Remove files executed at start up
for files in 45-pull-containers 49-cache-server 50-update-content 60-push-log
do
   rm -f /etc/hotplug.d/iface/$files
done

# Set back old password
# shellcheck disable=SC2016 # it's not a variable and doesn't need expanding
usermod --password '$1$.SwYxBkA$sIY5tCkbXGeK/cl/VcnRf0' cap
# Remove SSH public keys
rm -f /root/.ssh/authorized_keys
rm -f /home/cap/.ssh/authorized_keys

# Disable tinc
systemctl stop tinc@testvpn.service
systemctl disable tinc@testvpn.service
rm -rf /etc/tinc/

# Clean up balena-engine data
systemctl stop balena-engine
systemctl disable balena-engine
rm -rf /var/lib/balena-engine/

# Clean initcap
rm -f /var/spool/cron/crontabs/root
rm -f /usr/local/bin/initcap.py
rm -f /usr/local/bin/callback.py
rm -f /opt/*


# Clean data
rm -f /data
umount -A -l /dev/sda1
mkfs.ext4 -F /dev/sda1

## Reset hostname and SSID

# get eth first mac
addr=$( find /sys/class/net/ | grep -m1 'enp2s0' )
emac=$( awk -F":" '{ print $5 $6 }' "$addr/address" )

echo "Resetting the hostname to the factory one... (/etc/hostname, /etc/hosts)"
echo "CMAL-${emac}" > /etc/hostname
sed -i -e "s,$( awk -F" " ' /127.0.1.1/ { print $2 }' /etc/hosts ),CMAL-${emac},g" /etc/hosts

echo "Resetting the content host name... (uci)"
uci set system.@system[0].hostname=my.content
uci commit system

echo "Restting the SSID..."
uci set wireless.@wifi-iface[0].ssid=CMAL-2.4G-${emac}
uci set wireless.@wifi-iface[1].ssid=CMAL-5G-${emac}
uci commit wireless
