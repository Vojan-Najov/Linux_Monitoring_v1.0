
function count_subdirectories() {
	local DIRECTOTY="$1"

	if [ -z "$DIRECTORY" ]; then DIRECTORY="./"; fi

	echo "$(ls -lR 2>/dev/null "$DIRECTORY" | grep "^d" | wc -l)"
}

function get_largest_subdirectories() {
	local DIRECTOTY="$1"
	local array
	local i=0

	if [ -z "$DIRECTORY" ]; then DIRECTORY="./"; fi

	for d in ${DIRECTORY}*/
	do
		array[$i]=$(du -sb "$d" 2>/dev/null)
		i=$(( $i + 1 ))
	done

	IFS=$'\n' read -d '' -ra s < <(printf '%s\n' "${array[@]}" | sort -k1,1n)

	k=1
	for (( i=((${#s[@]} - 1)); i >= 0; --i ))
	do
		echo $i >tmp
		if [ -z "${s[$i]}" ]; then break; fi
		printf "%s - %s, %s\n" \
               "$k" \
               "$(echo ${s[$i]} | awk '{print $2}')" \
               "$(byte_converter $(echo ${s[$i]} | awk '{print $1}'))"
		k=$(( $k + 1 ))
		if [ $k -gt 5 ]; then break; fi
	done
}

function count_config_files() {
	local count=0

	while [ -n "$1" ]
	do
		if [[ "$1" =~ \.conf$ ]]
		then
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
		if [[ "$(file --mime-type $1)" =~ text ]]
		then
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
		if [ -x "$1" ]
		then
			count=$(( $count + 1 ))
		fi
		shift
	done

	echo "$count"
}

function count_log_files() {
	local count=0

	while [ -n "$1" ]
	do
		if [[ "$1" =~ \.log$ ]]
		then
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
		if [[ "$(file $1)" =~ (archive|compressed) ]]
		then
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

