#!/bin/bash


DIR_PATH=$(dirname $0)
DIRECTORY="$1"

. $DIR_PATH/byte_converter.sh
. $DIR_PATH/directory_info.sh

NO_ARG_ERR="Error: A relative or absolute path to the directory is expected."
ARG_NAME_ERR="Error: The argument must end in a backslash."
ARG_NOTDIR_ERR="Error: the directory ${DIRECTORY} does not exist."
ARG_READ_ERR="Error: The directory is not readable."

if [ -z "$DIRECTORY" ]; then echo "$NO_ARG_ERR"; exit 1; fi

if [ $(echo -n "$DIRECTORY" | tail -c 1) != "/" ]; then
  echo "$ARG_NAME_ERR"; exit 1
fi

if [ ! -d "$DIRECTORY" ]; then echo "$ARG_NOTDIR_ERR"; exit 1; fi

if [ ! -r "$DIRECTORY" ]; then echo "$ARG_READ_ERR"; exit 1; fi


printf "Total number of folders (including all nested ones) = %s\n" \
       "$(count_subdirectories "$DIRECTORY" )"

printf \
"TOP 5 folders of maximum size arranged in descending order (path and size):\n%s\n" \
"$(get_largest_subdirectories)"

files=($(find $DIRECTORY -type f -print 2>/dev/null))
links=($(find $DIRECTORY -type l -print 2>/dev/null))

printf "Total number of files = %s\n" "${#files[@]}"

printf "Number of:\n"

printf "Configuration files (with the .conf extension) = %s\n" \
       "$(count_config_files ${files[@]})"

printf "Text files = %s\n" \
       "$(count_text_files ${files[@]})"

printf "Executable files = %s\n" \
       "$(count_executable_file ${files[@]})"

printf "Log files (with the extension .log) = %s\n" \
       "$(count_log_files ${files[@]})"

printf "Archive files = %s\n" \
       "$(count_archive_files ${files[@]})"

printf "Symbolic links = %s\n" "${#links[@]}"

printf \
"TOP 10 files of maximum size arranged in descending order (path, size and type):\n%s\n" \ 
"$(get_10_largest_files ${files[@]})"

printf "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):\n%s\n" \
"$(get_10_largest_executable_files ${files[@]})"

