#!/bin/bash



if ! which git >/dev/null; then
    if ! sudo -v; then
        echo "sudo failed; aborting."
        exit 1
    fi
    sudo apt-get install -y git
fi

git config --global user.email "damc.dev@gmail.com"
git config --global user.name "David McElligott"

