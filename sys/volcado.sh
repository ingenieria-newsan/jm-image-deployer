#! /bin/bash

# volcado de imagen
# sudo /usr/sbin/ocs-sr -g auto -e1 auto -e2 -r -j2 -batch -scr -p true restoredisk JM-v1002 ${1} #### DEBUG !!

printf "\n\t CLONADO DUMMY WAIT 10s..."
sleep 10

# aviso sonoro de que finalizo el proceso
sudo timeout 1.5 speaker-test --frequency 500 --test sine > /dev/null 2>&1

