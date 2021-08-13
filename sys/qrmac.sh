#! /bin/bash
echo -e
echo -e
echo -e
echo -e
echo -e
echo -e
echo -e
echo -e
echo -e
echo -e
mac=$(ip addr show $(awk 'NR==3{print $1}' /proc/net/wireless | tr -d :) | awk '/ether/{print $2}' | sed "s/://g")
qrencode -t ansi256 ${mac^^}
sleep 3
