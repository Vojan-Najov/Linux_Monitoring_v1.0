#!/bin/bash

DIR_NAME=$(dirname $0)
ARG_ERR="Error: the parameter is a number."
ARG_NUMBER_ERR="Error: one parameter is expected."

. $DIR_NAME/isnumber.sh

if [ $# -eq 1 ]
then
  isnumber $1
  if [ $? -eq 1 ]
  then
    echo "$1"
  else
    echo "$ARG_ERR"
  fi
else
  echo "$ARG_NUMBER_ERR"
fi

