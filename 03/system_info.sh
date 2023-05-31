function get_hostname() {
  local HOSTNAME=$(cat /etc/hostname)

  echo "$HOSTNAME"
}

function get_timezone() {
  local TIMEZONE=$(cat /etc/timezone)
  local UTC_OFFSET=$(date +%:::z)

  echo "$TIMEZONE UTC $UTC_OFFSET"
}

function get_os() {
  local OS=$(uname -o)
  local OS_NAME=$(cat /etc/os-release | grep ^NAME= | cut -c 6- | tr -d \")
  local OS_VERSION=$(cat /etc/os-release | grep ^VERSION= | cut -c 9- | tr -d \")

  echo "$OS $OS_NAME $OS_VERSION"
}

function get_date() {
  local DATE_FORMAT="%d %b %Y %l:%M:%S"
  local DATE=$(date +"$DATE_FORMAT")

  echo "$DATE"
}

function get_uptime() {
  UPTIME=$(uptime -p | cut -c 4-)

  echo "$UPTIME"
}

function get_uptime_sec() {
  local UPTIME_SINCE=$(uptime -s)
  local UPTIME_SEC_START=$(date --date="$UPTIME_SINCE" +"%s")
  local UPTIME_SEC_NOW=$(date --date="now" +"%s")
  local UPTIME_SEC=0

  let "UPTIME_SEC = $UPTIME_SEC_NOW - $UPTIME_SEC_START"
  echo "$UPTIME_SEC"
}

function get_ip() {
  local IP=$(ip -4 address | grep -v lo$ | awk '/inet/{print$2}')

  if [ -z "$IP" ]
  then
    IP=$(ip -4 address | awk '/inet/{print$2}')
  fi

  echo "$IP"
}

function get_netmask() {
  #local NETMASK=$(ipcalc $IP | awk '/Netmask/{print$2}')
  #echo "$NETMASK"
  local masks=("0.0.0.0" "128.0.0.0" "192.0.0.0"
               "224.0.0.0" "240.0.0.0" "248.0.0.0"
               "252.0.0.0" "254.0.0.0" "255.0.0.0"
               "255.128.0.0" "255.192.0.0" "255.224.0.0"
               "255.240.0.0" "255.248.0.0" "255.252.0.0"
               "255.254.0.0" "255.255.0.0" "255.255.128.0"
               "255.255.192.0"  "255.255.224.0" "255.255.240.0"
               "255.255.248.0" "255.255.252.0"  "255.255.254.0"
               "255.255.255.0"  "255.255.255.128"  "255.255.255.192"
               "255.255.255.224" "255.255.255.240" "255.255.255.248"
               "255.255.255.252" "255.255.255.254"  "255.255.255.255")

  if [[ $1 -ge 0 && $1 -le 32 ]]
  then
    echo ${masks[$1]}
  fi
}

function get_gateway() {
  GATEWAY=$(ip route list | awk '/default/{print$3}')

  echo "$GATEWAY"
}

function get_ram_info() {
  local MEM_INFO=$(free -b | grep Mem)
  local RAM_TOTAL_B=$(echo $MEM_INFO | awk '/Mem/{print$2}')
  local RAM_USED_B=$(echo $MEM_INFO | awk '/Mem/{print$3}')
  local RAM_FREE_B=$(echo $MEM_INFO | awk '/Mem/{print$4}')
  local RAM_TOTAL=$(echo "scale = 3; $RAM_TOTAL_B / 1000.0 / 1000.0 / 1000.0" | \
                    bc | awk '{printf "%.3f", $0}')
  local RAM_USED=$(echo "scale = 3; $RAM_USED_B / 1000.0 / 1000.0 / 1000.0" | \
                   bc | awk '{printf "%.3f", $0}')
  local RAM_FREE=$(echo "scale = 3; $RAM_FREE_B / 1000.0 / 1000.0 / 1000.0" | \
                   bc | awk '{printf "%.3f", $0}')

  echo "$RAM_TOTAL GB;$RAM_USED GB;$RAM_FREE GB"
}

function get_space_info() {
  local DF_INFO=$(df --block-size=1 / | grep /)
  local SPACE_ROOT_B=$(echo $DF_INFO | awk '//{print$2}')
  local SPACE_ROOT_USED_B=$(echo $DF_INFO | awk '//{print$3}')
  local SPACE_ROOT_FREE_B=$(echo $DF_INFO | awk '//{print$4}')
  local SPACE_ROOT=$(echo "scale = 2; $SPACE_ROOT_B / 1000.0 / 1000.0" | \
                     bc | awk '{printf "%.2f", $0}')
  local SPACE_ROOT_USED=$(echo "scale = 2; $SPACE_ROOT_USED_B / 1000.0 / 1000.0" | \
                          bc | awk '{printf "%.2f", $0}')
  local SPACE_ROOT_FREE=$(echo "scale = 2; $SPACE_ROOT_FREE_B / 1000.0 / 1000.0" | \
                          bc | awk '{printf "%.2f", $0}')


  echo "$SPACE_ROOT MB;$SPACE_ROOT_USED MB;$SPACE_ROOT_FREE MB"
}

function color() {
  local foreground=$2
  local background=$1
  local color

  if [ "$foreground" == "" ]; then foreground="default"; fi
  if [ "$background" == "" ]; then background="default"; fi

  case "$foreground" in
    "default") color='\033[0;39m';;
    "white")   color='\033[0;37m';;
    "red")     color='\033[0;31m';;
    "green")   color='\033[0;32m';;
    "blue")    color='\033[0;34m';;
    "purple")  color='\033[0;35m';;
    "black")   color='\033[0;30m';;
    *)         color='\033[0;39m';;
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
  local IP; local MASK; local RAM_INFO; local SPACE_INFO

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
  IP=$(get_ip)
  IFS='\n' read -ra IP <<< $IP
  IFS='/' read -ra IP <<< ${IP[0]}
  MASK=${IP[1]}; IP=${IP[0]}
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "IP" "$IP"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "MASK" "$(get_netmask $MASK)"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "GATEWAY" "$(get_gateway)"
  RAM_INFO=$(get_ram_info)
  IFS=';' read -ra RAM_INFO <<< $RAM_INFO
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_TOTAL" "${RAM_INFO[0]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_USED" "${RAM_INFO[1]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "RAM_FREE" "${RAM_INFO[2]}"
  SPACE_INFO=$(get_space_info)
  IFS=';' read -ra SPACE_INFO <<< $SPACE_INFO
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_TOTAL" "${SPACE_INFO[0]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_USED" "${SPACE_INFO[1]}"
  printf "$(color $1 $2)%s${reset_color} = $(color $3 $4)%s${reset_color}\n" \
         "SPACE_ROOT_FREE" "${SPACE_INFO[2]}"
}

