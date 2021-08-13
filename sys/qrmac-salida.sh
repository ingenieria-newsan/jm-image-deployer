#! /bin/bash
mac=$(ip addr show $(awk 'NR==3{print $1}' /proc/net/wireless | tr -d :) | awk '/ether/{print $2}' | sed "s/://g")
qrencode -t ansi256 ${mac^^}
echo -e
serial=$(lsblk --nodeps -no serial /dev/${1})
qrencode -t ansi256 $serial
sleep 3
#echo presione enter para salir
#read -p ""
