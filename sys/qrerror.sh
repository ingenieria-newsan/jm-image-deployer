#! /bin/bash
aux=$(ip addr show $(awk 'NR==3{print $1}' /proc/net/wireless | tr -d :) | awk '/ether/{print $2}' | sed "s/://g")
mac=${aux^^}
codigo='{"unitValue":"'${mac}'","station":"VOLCADO","code":"'${1}'"}'
echo -e
qrencode -t ansi256 $codigo
read -p ""
