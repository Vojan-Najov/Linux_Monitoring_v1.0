#!/bin/bash

IP=$(ip -4 address | grep -v lo$ | awk '/inet/{print$2}')
if [ -z "$IP" ]
then
  IP=$(ip -4 address | awk '/inet/{print$2}')
else
  IFS='\n' read -ra IP_ARRAY <<< "$IP"
  IP=${IP_ARRAY[0]}
fi

NETMASK=$(ipcalc $IP | awk '/Netmask/{print$2}')

GATEWAY=$(ip route list | awk '/default/{print$3}')

echo "IP = $IP"
echo "NETMASK = $NETMASK"
echo "GATEWAY = $GATEWAY"

