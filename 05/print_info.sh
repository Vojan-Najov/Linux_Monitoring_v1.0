
function print_info() {
  local directory="$1"
  local files=($(find "$directory" -type f -print 2>/dev/null))
  local links=($(find "$directory" -type l -print 2>/dev/null))

  printf "Total number of folders (including all nested ones) = %s\n" \
         "$(count_subdirectories "$directory" )"

  printf "TOP 5 folders of maximum size arranged in descending order `
         `(path and size):\n%s\n" "$(get_largest_subdirectories $directory)"

  printf "Total number of files = %s\n" "${#files[@]}"

  printf "Number of:\n"
  printf "Configuration files (with the .conf extension) = %s\n" \
         "$(count_config_files ${files[@]})"

  printf "Text files = %s\n" "$(count_text_files ${files[@]})"

  printf "Executable files = %s\n" "$(count_executable_file ${files[@]})"

  printf "Log files (with the extension .log) = %s\n" "$(count_log_files ${files[@]})"

  printf "Archive files = %s\n" "$(count_archive_files ${files[@]})"

  printf "Symbolic links = %s\n" "${#links[@]}"

  printf "TOP 10 files of maximum size arranged in descending order `
         `(path, size and type):\n%s\n" "$(get_10_largest_files ${files[@]})"

  printf "TOP 10 executable files of the maximum size arranged in descending order `
         `(path, size and MD5 hash of file):\n%s\n" \
         "$(get_10_largest_executable_files ${files[@]})"
}

