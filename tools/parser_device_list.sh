#!/bin/bash

curl -sfL https://github.com/ideascube/ansiblecube/raw/oneUpdateFile/roles/set_custom_fact/files/device_list.fact | egrep "idc-|idb-|kb-" | grep ":" |sed 's/"//g' |sed 's/  //g' | cut -d ":" -f1 > /tmp/device.txt
wget https://github.com/ideascube/ansiblecube/raw/oneUpdateFile/roles/set_custom_fact/files/device_list.fact -O /tmp/device_list.fact
while IFS= read NAME
do
  UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  PACKAGES=$(cat /tmp/device_list.fact |jq -c ."\"$NAME\".package_management")
  KOLIBRI=$(cat /tmp/device_list.fact |jq ."\"$NAME\".kalite.activated")

  if [[ $KOLIBRI && true ]]; then

    KOLIBRI_LANG=$(cat /tmp/device_list.fact |jq -c ."\"$NAME\".kalite.language")
    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://10.10.9.38:1337/projects/ -d '{"process_id" : "'"$UUID"'","containers" : [{"name" : "ideascube","image_id" : "bibliosansfrontieres/ideascube-i386:0.37.7","content" : '${PACKAGES}' },{"name" : "kiwix","image_id" : "bibliosansfrontieres/kiwix-i386:latest"},{"name" : "kolibri","image_id" : "bibliosansfrontieres/kolibri-i386:latest","content" : '$KOLIBRI_LANG'}],"project_name" : "'"$NAME"'","timezone" : "Europe/Paris"}'

  else

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://10.10.9.38:1337/projects/ -d '{"process_id" : "'"$UUID"'","containers" : [{"name" : "ideascube","image_id" : "bibliosansfrontieres/ideascube-i386:0.37.7","content" : '${PACKAGES}' },{"name" : "kiwix","image_id" : "bibliosansfrontieres/kiwix-i386:latest"}],"project_name" : "'"$NAME"'","timezone" : "Europe/Paris"}'

  fi

done < /tmp/device.txt
