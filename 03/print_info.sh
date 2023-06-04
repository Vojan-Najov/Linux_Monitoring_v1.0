
function color() {
  local foreground="$2"
  local background="$1"
  local color

  if [ -z "$foreground" ]; then foreground="default"; fi
  if [ -z "$background" ]; then background="default"; fi

  case "$foreground" in
    "default") color='\033[1;39m';;
    "white")   color='\033[1;37m';;
    "red")     color='\033[1;31m';;
    "green")   color='\033[1;32m';;
    "blue")    color='\033[1;34m';;
    "purple")  color='\033[1;35m';;
    "black")   color='\033[1;30m';;
    *)         color='\033[1;39m';;
  esac

  case "$background" in
    "default") color="${color}\033[49m";;
    "white")   color="${color}\033[47m";;
    "red")     color="${color}\033[41m";;
    "green")   color="${color}\033[42m";;
    "blue")   color="${color}\033[44m";;
    "purple")  color="${color}\033[45m";;
    "black")   color="${color}\033[40m";;
    *)         color="${color}\033[49m";;
    esac

    echo "${color}"
}

function print_info() {
  local reset_color="\033[0m"
  local RAM_INFO
  local SPACE_INFO

  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "HOSTNAME" "$(get_hostname)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "TIMEZONE" "$(get_timezone)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "USER" "$USER"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "OS" "$(get_os)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "DATE" "$(get_date)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "UPTIME" "$(get_uptime)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "UPTIME_SEC" "$(get_uptime_sec)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "IP" "$(get_ip)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "MASK" "$(get_netmask)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "GATEWAY" "$(get_gateway)"
  IFS=$';' read -ra RAM_INFO <<< "$(get_ram_info)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_TOTAL" "${RAM_INFO[0]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_USED" "${RAM_INFO[1]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_FREE" "${RAM_INFO[2]}"
  IFS=$';' read -ra SPACE_INFO <<< "$(get_space_info)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_TOTAL" "${SPACE_INFO[0]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_USED" "${SPACE_INFO[1]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_FREE" "${SPACE_INFO[2]}"
}

