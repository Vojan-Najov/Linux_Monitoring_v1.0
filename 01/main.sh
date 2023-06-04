#!/bin/bash

DIR_PATH=$(dirname $0)

ARG_ERR="Error: the parameter is a number."
ARG_NUMBER_ERR="Error: one parameter is expected."

. $DIR_PATH/isnumber.sh

if [ $# -ne 1 ]; then echo "$ARG_NUMBER_ERR"; exit 1; fi

isnumber "$1"
if [ $? -eq 1 ]; then echo "$ARG_ERR"; exit 1; fi

echo "$1"

