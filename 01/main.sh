#!/bin/bash

ARG_ERR="Error: the parameter is a number."
NOARG_ERR="Error: one parameter is expected."

if [[ $# -eq 1 ]]
then
  if [[ "$1" =~ ^[-+]?[0-9]+.?[0-9]*[eE]?[-+]?[0-9].$ ]]
  then
    echo "$ARG_ERR"
  else
    echo "$1"
  fi
else
  echo "$NOARG_ERR"
fi

