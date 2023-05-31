#!/bin/bash

WHITE=1; RED=2; GREEN=3; BLUE=4; PURPLE=5; BLACK=6
ARG_ERR="Error: numeric parameters are expected."
ARG_RANGE_ERR="Error: arguments from 1 to 6 are accepted."
ARG_EQUAL_ERR="Error: the background and font colors should not match."
CONFIG_ERR="Error: incorrect config file."
DIR_PATH=$(dirname $0)
CONFIG_FILE="$DIR_PATH/monitoring.conf"

COLORS=(0 0 0 0)
DEFAULT_COLORS=(6 1 6 1)
DEFAULT_SETTINGS=1


. $DIR_PATH/isnumber.sh
. $DIR_PATH/system_info.sh
. $DIR_PATH/print_settings.sh

if [ -s ${CONFIG_FILE} ]
then
  DEFAULT_SETTINGS=0
  for line in $(cat ${CONFIG_FILE})
  do
    IFS='=' read -ra token <<< ${line}
    num=${token[1]}
    isnumber $num
    if [ $? -eq 1 ]; then echo "$ARG_ERR"; exit 1; fi
    if [[ $num -lt 1 || $num -gt 6 ]]; then echo "$ARG_RANGE_ERR"; exit 1; fi
    case "${token[0]}" in
      "column1_background") COLORS[0]=$num;;
      "column1_font_color") COLORS[1]=$num;;
      "column2_background") COLORS[2]=$num;;
      "column2_font_color") COLORS[3]=$num;;
      "*") echo "$CONFIG_ERR"; exit 1
    esac
  done
  for (( i=0; i < 4; ++i ))
  do
    if [ COLORS[$i] -eq 0 ]; then COLORS[$i]=${DEFAULT_COLORS[$i]}; fi
  done
else
  for (( i=0; i < 4; ++i ))
  do
    COLORS[$i]=${DEFAULT_COLORS[$i]}
  done
fi

if [[ ${COLORS[0]} -eq ${COLORS[1]} || ${COLORS[2]} -eq ${COLORS[3]} ]]
then
  echo "$ARG_EQUAL_ERR"
  echo "Try again."
  exit 1
fi

for (( i=0; i < 4; ++i ))
do
  case ${COLORS[$i]} in
    $WHITE) COLORS[$i]="white" ;;
    $RED) COLORS[$i]="red" ;;
    $GREEN) COLORS[$i]="green" ;;
    $BLUE) COLORS[$i]="blue" ;;
    $PURPLE) COLORS[$i]="purple" ;;
    $BLACK) COLORS[$i]="black" ;;
  esac
done

print_info ${COLORS[*]}

print_settings $DEFAULT_SETTINGS ${COLORS[@]}

