#!/bin/sh

# This script soft reset the CAP and format the HHD

# Erase the current configuration with a backup
cd / && tar xvf /etc/factory-config.tgz

# get eth first mac and get the laste 2 numbers
addr=`find /sys/class/net/ | grep -m1 'enp2s0'`
emac=`cat $addr/address | awk -F":" '{ print $5 $6 }'`

# Set a default hostname
echo "CMAL-$emac" > /etc/hostname

# Set back old password
usermod --password '$1$.SwYxBkA$sIY5tCkbXGeK/cl/VcnRf0' cap

# Clean up balena-engine data
systemctl stop balena-engine
systemctl disable balena-engine
rm -rf /var/lib/balena-engine/

# Force umount the HDD
umount -A -l /dev/sda1

# Format the partition
mkfs.ext4 -F /dev/sda1

# Shutdown the device
sudo reboot
