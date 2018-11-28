#!/usr/bin/env bash

cd /Users/kate/code/script/vagrant

HOSTS=$(cat ssh-hosts)

for HOST in ${HOSTS}
do
    echo ${HOST}
    ssh-copy-id vagrant@${HOST}
done