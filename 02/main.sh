#!/bin/bash

DIR_PATH=$(dirname $0)
FILENAME=$(date +"%d_%m_%y_%H_%M_%S.status")

. $DIR_PATH/system_info.sh

function print_info {
  echo "HOSTNAME = $(get_hostname)"
  echo "TIMEZONE = $(get_timezone)"
  echo "USER = $USER"
  echo "OS = $(get_os)"
  echo "DATE = $(get_date)"
  echo "UPTIME = $(get_uptime)"
  echo "UPTIME_SEC = $(get_uptime_sec)"
  local IP=$(get_ip)
  IFS='\n' read -ra IP_ARRAY <<< $IP; IP=${IP_ARRAY[0]}
  echo "IP = $IP"
  IFS='/' read -ra IP_ARRAY <<< $IP; MASK=${IP_ARRAY[1]}
  echo "MASK = $(get_netmask $MASK)"
  echo "GATEWAY = $(get_gateway)"
  local RAM_INFO=$(get_ram_info)
  IFS=';' read -ra RAM_ARRAY <<< $RAM_INFO
  echo "RAM_TOTAL = ${RAM_ARRAY[0]}"
  echo "RAM_USED = ${RAM_ARRAY[1]}"
  echo "RAM_FREE = ${RAM_ARRAY[2]}"
  local SPACE_INFO=$(get_space_info)
  IFS=';' read -ra SPACE_ARRAY <<< $SPACE_INFO
  echo "SPACE_ROOT_TOTAL = ${SPACE_ARRAY[0]}"
  echo "SPACE_ROOT_USED = ${SPACE_ARRAY[1]}"
  echo "SPACE_ROOT_FREE = ${SPACE_ARRAY[2]}"
}

print_info

read -p "Write data to a file (Y/N)? " ANSWER
if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]
then
  print_info >$FILENAME
fi

