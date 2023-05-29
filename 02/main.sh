#!/bin/bash

DIR_PATH=$(dirname $0)
FILENAME=$(date +"%d_%m_%y_%H_%M_%S.status")

function print_info {
  $DIR_PATH/print_host_info.sh
  $DIR_PATH/print_date_info.sh
  $DIR_PATH/print_net_info.sh
  $DIR_PATH/print_ram_info.sh
  $DIR_PATH/print_space_info.sh
}

print_info

echo "Write data to a file? Y/N"
read ANSWER

if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]
then
  print_info >$FILENAME
fi

