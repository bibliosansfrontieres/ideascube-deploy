#!/bin/sh

rm -Rf /data/library.xml

find /data -name '*.zim' |
while read filename
do
    /opt/kiwix-serve/kiwix-manage /data/library.xml add $filename
    killall -TERM kiwix-serve
done
