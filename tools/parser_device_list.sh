#!/bin/bash

while IFS= read NAME
do
  UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  PACKAGES=$(curl -sfL https://github.com/ideascube/ansiblecube/raw/oneUpdateFile/roles/set_custom_fact/files/device_list.fact |jq -c ."\"$NAME\".package_management")
  KOLIBRI=$(curl -sfL https://github.com/ideascube/ansiblecube/raw/oneUpdateFile/roles/set_custom_fact/files/device_list.fact |jq ."\"$NAME\".kalite.activated")

  if [[ "$KOLIBRI" = "True" ]]; then

    KOLIBRI_LANG=$(cat device_list.fact |jq -c ."\"$NAME\".kalite.language")
    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:1337/devices/ -d '{"process_id" : "'"$UUID"'","containers" : [{"name" : "ideascube","image_id" : "bibliosansfrontieres/ideascubepp:0.37.7","content" : '$PACKAGES' },{"name" : "kiwix","image_id" : "bibliosansfrontieres/kiwix:latest","content" : [ ]},{"name" : "kolibri","image_id" : "bibliosansfrontieres/kolibri:latest","content" : '$KOLIBRI_LANG'}],"project_name" : "'"$NAME"'","timezone" : "Europe/Paris"}'

  else

    curl -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:1337/devices/ -d '{"process_id" : "'"$UUID"'","containers" : [{"name" : "ideascube","image_id" : "bibliosansfrontieres/ideascubepp:0.37.7","content" : '${PACKAGES}' },{"name" : "kiwix","image_id" : "bibliosansfrontieres/kiwix:latest","content" : [ ]}],"project_name" : "'"$NAME"'","timezone" : "Europe/Paris"}'

  fi

done < device.txt
