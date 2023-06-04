
function count_subdirectories() {
	local directory="$1"

	if [ -z "$directory" ]; then directory="./"; fi

	echo "$(ls -lR "$directory" 2>/dev/null | grep ^d | wc -l)"
}

function get_largest_subdirectories() {
  local directory="$1"
  local subdirs
  local i; local k

  if [ -z "$directory" ]; then directory="./"; fi
 
  i=0 
  for d in "${directory}"*/
  do
    subdirs[$i]=$(du -s --block-size=1 "$d" 2>/dev/null)
    i=$(( $i + 1 ))
  done

  IFS=$'\n' read -d '' -ra subdirs < <(printf '%s\n' "${subdirs[@]}" | sort -k1,1n)

  k=1
  for (( i=((${#subdirs[@]} - 1)); i >= 0; --i ))
  do
    if [ -z "${subdirs[$i]}" ]; then break; fi
    printf "%s - %s, %s\n" \
           "$k" \
           "$(echo ${subdirs[$i]} | awk '{print $2}')" \
           "$(byte_converter $(echo ${subdirs[$i]} | awk '{print $1}'))"
    k=$(( $k + 1 ))
    if [ $k -gt 5 ]; then break; fi
  done
}

function count_config_files() {
  local count=0
  local filename

  while [ -n "$1" ]
  do
    filename=$(basename "$1")
    if [[ "$filename" =~ ^[[:print:]]+\.conf$ ]]; then
      count=$(( $count + 1 ))
    fi
    shift
  done

  echo "$count"
}

function count_text_files() {
  local count=0

  while [ -n "$1" ]
  do
    if [[ "$(file --mime-type $1 | awk -F ':' '{print $2}' )" =~ text ]]; then
      count=$(( $count + 1 ))
    fi
    shift
  done

  echo "$count"
}

function count_executable_file() {
  local count=0

  while [ -n "$1" ]
  do
    if [ -x "$1" ]; then
      count=$(( $count + 1 ))
    fi
    shift
  done

  echo "$count"
}

function count_log_files() {
  local count=0
  local filename

  while [ -n "$1" ]
  do
    filename=$(basename "$1")
    if [[ "$filename" =~ ^[[:print:]]+\.log$ ]]; then
      count=$(( $count + 1 ))
    fi
    shift
  done

  echo "$count"
}

function count_archive_files() {
  local count=0

  while [ -n "$1" ]
  do
    if [[ "$(file $1 | awk -F ':' '{print$2}')" =~ (archive|compressed) ]]; then
      count=$(( $count + 1 ))
    fi
    shift
  done

  echo "$count"
}

function get_10_largest_files() {
	local files
	local i

	i=0
	while [ -n "$1" ]
	do
		filename="$1"
		filesize="$(du --block-size=1 $1 | awk '{print $1}')"
		IFS=$'.' read -ra arr <<<"$(basename $filename)"
		if [ ${#arr[@]} -gt 1 ]
		then
			filetype="${arr[${#arr[@]} - 1]}"
		else
			filetype="$(file --mime-type $filename | awk -F ':' '{print $2}')"
		fi
		files[$i]="$filename $filesize $filetype"
		i=$(( $i + 1 ))
		shift
	done

	IFS=$'\n' read -d '' -ra s < <(printf '%s\n' "${files[@]}" | sort -k2,2n)

	k=1
	for (( i=((${#s[@]} - 1)); i >= 0; --i ))
	do
		printf "%s - %s, %s, %s \n" \
               "$k" \
               "$(echo ${s[$i]} | awk '{print $1}')" \
               "$(byte_converter $(echo ${s[$i]} | awk '{print $2}'))" \
               "$(echo ${s[$i]} | awk '{print $3}')"
        k=$(( $k + 1 ))
		if [ $k -gt 10 ]; then break; fi
	done
}

function get_10_largest_executable_files() {
	local files
	local i

	i=0
	while [ -n "$1" ]
	do
		filename="$1"
		if [ ! -x "$filename" ]; then shift; continue; fi
		filesize="$(du --block-size=1 $1 | awk '{print $1}')"
		filehash="$(md5sum $filename | awk '{print $1}')"
		files[$i]="$filename $filesize $filehash"
		i=$(( $i + 1 ))
		shift
	done

	IFS=$'\n' read -d '' -ra s < <(printf '%s\n' "${files[@]}" | sort -k2,2n)

	k=1
	for (( i=((${#s[@]} - 1)); i >= 0; --i ))
	do
		printf "%s - %s, %s, %s \n" \
               "$k" \
               "$(echo ${s[$i]} | awk '{print $1}')" \
               "$(byte_converter $(echo ${s[$i]} | awk '{print $2}'))" \
               "$(echo ${s[$i]} | awk '{print $3}')"
        k=$(( $k + 1 ))
		if [ $k -gt 10 ]; then break; fi
	done
}

