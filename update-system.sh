#!/bin/bash

set -e

if [ "$UID" != "0" ]; then
    echo "Run me as root"
    exit 126
fi
MODE="$1"


function install_base() {
    echo "Setup Docker official repository"
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
    apt-get install apt-transport-https ca-certificates  curl  gnupg2  software-properties-common
    add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
           $(lsb_release -cs) \
           stable"

    echo "Docker compose"
    curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    curl -L https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

    echo "Updating packages"
    apt-get update
    apt-get install  $(cat custom-packages.list) 
}

if [ "$MODE" == "install" ]; then 
    install_base
fi

echo "Showing upcoming changes..."
rsync --dry-run -av target/* /

echo -n "Apply changes? [ENTER to continue, Ctrl-C to abort]"
read STDIN

rsync -av target/* /
