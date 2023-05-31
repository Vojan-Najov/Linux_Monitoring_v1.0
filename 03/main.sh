#!/bin/bash

WHITE=1
RED=2
GREEN=3
BLUE=4
PURPLE=5
BLACK=6
ARG_ERR="Error: numeric parameters are expected."
ARG_NUMBER_ERR="Error: 4 numeric parameters are expected."
ARG_RANGE_ERR="Error: arguments from 1 to 6 are accepted."
ARG_EQUAL_ERR="Error: the background and font colors should not match."
DIR_PATH=$(dirname $0)

declare -a COLORS

. $DIR_PATH/isnumber.sh
. $DIR_PATH/system_info.sh

if [ $# -ne 4 ]
then
  echo "$ARG_NUMBER_ERR"
  exit 1
fi

i=0
while [ -n "$1" ]
do
  isnumber "$1"
  if [ $? -eq 1 ]
  then
    echo "$ARG_ERR"
    exit 1
  fi
  if [[ $1 -lt 1 || $1 -gt 6 ]]
  then
    echo "$ARG_RANGE_ERR"
    exit 1
  fi
  COLORS[$i]=$1
  shift
  i=$(( $i + 1 ))
done

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

