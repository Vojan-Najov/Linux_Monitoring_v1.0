#!/bin/bash

DIR_PATH=$(dirname $0)
DIRECTORY="$1"

. "$DIR_PATH"/byte_converter.sh
. "$DIR_PATH"/directory_info.sh
. "$DIR_PATH"/print_info.sh

NO_ARG_ERR="Error: A relative or absolute path to the directory is expected."
ARG_NAME_ERR="Error: The argument must end in a backslash."
ARG_NOTDIR_ERR="Error: the directory ${DIRECTORY} does not exist."
ARG_READ_ERR="Error: The directory  ${DIRECTORY} is not readable."

if [ -z "$DIRECTORY" ]; then echo "$NO_ARG_ERR"; exit 1; fi

if [ $(echo -n "$DIRECTORY" | tail -c 1) != "/" ]; then
  echo "$ARG_NAME_ERR"; exit 1
fi

if [ ! -d "$DIRECTORY" ]; then echo "$ARG_NOTDIR_ERR"; exit 1; fi

if [ ! -r "$DIRECTORY" ]; then echo "$ARG_READ_ERR"; exit 1; fi

TIMEFORMAT="Script execution time (in seconds) = %1R"
time {
  print_info "$DIRECTORY"
}

