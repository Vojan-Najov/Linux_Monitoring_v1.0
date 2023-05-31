#!/bin/bash

DIR_PATH=$(dirname $0)
FILENAME=$(date +"%d_%m_%y_%H_%M_%S.status")

. $DIR_PATH/system_info.sh
. $DIR_PATH/print_info.sh

print_info

read -p "Write data to a file (Y/N)? " ANSWER
if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]
then
  print_info >$FILENAME
fi

