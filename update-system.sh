#!/bin/bash

set -e

if [ "$UID" != "0" ]; then
    echo "Run me as root"
    exit 126
fi

echo "Updating packages"
apt-get update
apt-get install  $(cat custom-packages.list) 

echo "Showing upcoming changes..."
rsync --dry-run -av target/* /

echo -n "Apply changes? [ENTER to continue, Ctrl-C to abort]"
read STDIN

rsync -av target/* /
