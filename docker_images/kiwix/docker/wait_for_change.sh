#!/bin/sh

# ensure the content folder already exists
mkdir -p /data/content

# watch it
echo "Waiting for file change in /data/content"

inotifywait -m /data/content -e create -e delete |
    while read path action file; do
        echo "The file '$file' appeared in directory '$path' via '$action'"
        /docker/rebuild_library.sh

        supervisorctl restart kiwix-serve
        # do something with the file
done
