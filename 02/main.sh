#!/bin/bash

DIR_PATH="$(dirname $0)"

. "$DIR_PATH"/system_info.sh
. "$DIR_PATH"/print_info.sh

print_info

echo; read -p "Write data to a file (Y/N)? " ANSWER
if [[ "$ANSWER" = "y" || "$ANSWER" = "Y" ]]; then
  FILENAME="$(date +"%d_%m_%y_%H_%M_%S.status")"
  print_info >"$FILENAME"
fi

