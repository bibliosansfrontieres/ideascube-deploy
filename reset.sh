#!/bin/sh

cd / && tar xvf /etc/config-backup.tar.gz

r2f=`uci get system.@system[0].r2f`

[ "$r2f" = 0 ] && uci set system.@system[0].r2f=1 && uci commit system

# get eth first mac
addr=`find /sys/class/net/ | grep -m1 'enp2s0'`
emac=`cat $addr/address | awk -F":" '{ print $5 $6 }'`

# hostname
echo "CMAL-$emac" > /etc/hostname
sed -i -e "s,$(cat /etc/hosts | grep 127.0.1.1 | awk -F" " '{ print $2 }'),CMAL-$emac,g" /etc/hosts

# content host name
uci set system.@system[0].hostname=my.content
uci commit system

# ssid
uci set wireless.@wifi-iface[0].ssid=CMAL-2.4G-$emac
uci set wireless.@wifi-iface[1].ssid=CMAL-5G-$emac

uci commit wireless

sync

umount -A -l /dev/sda1
mkfs.ext4 /dev/sda1

sudo poweroff
