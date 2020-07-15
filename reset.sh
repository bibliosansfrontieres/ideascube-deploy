#!/bin/sh

# This script soft reset the CAP and format the HHD

if [ "$(id -u)" != 0 ]; then
   >&2 echo "Error: this script must be run as root."
   exit 13  # EACCES
fi

# Erase the current configuration with a backup
cd / && tar xvf /etc/factory-config.tgz

# get eth first mac and get the laste 2 numbers
addr=$( find /sys/class/net/ | grep -m1 'enp2s0' )
emac=$( awk -F":" '{ print $5 $6 }' "$addr/address" )

# Set a default hostname
echo "CMAL-$emac" > /etc/hostname

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

# Shutdown the device
reboot
