function get_hostname() {
  local HOSTNAME=$(cat /etc/hostname)

  echo "$HOSTNAME"
}

function get_timezone() {
  local TIMEZONE=$(cat /etc/timezone)
  local UTC_OFFSET=$(date +%:::z)

  printf "%s UTC %+d\n" "$TIMEZONE" "$UTC_OFFSET"
}

function get_os() {
  local OS=$(uname -o)
  local OS_NAME=$(cat /etc/os-release | grep ^NAME= | cut -c 6- | tr -d \")
  local OS_VERSION=$(cat /etc/os-release | grep ^VERSION= | cut -c 9- | tr -d \")

  echo "$OS $OS_NAME $OS_VERSION"
}

function get_date() {
  local DATE_FORMAT="%d %b %Y %H:%M:%S"
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

function get_all_ip() {
  local IP
  local IP_ARRAY

  IP=$(ip -4 address | grep -v lo$ | awk '/inet/{print$2}')
  if [ -z "$IP" ]
  then
    IP=$(ip -4 address | awk '/inet/{print$2}')
  fi
  echo "$IP"
}

function get_ip() {
  local IP
  local IP_ARRAY

  IP="$(get_all_ip)"
  IFS=$'\n' read -ra IP_ARRAY <<< "$IP"
  IP="$(echo ${IP_ARRAY[0]} | awk -F '/' '{print $1}')"
  echo "$IP"
}

#function get_netmask() {
#  local NETMASK=$(ipcalc $IP | awk '/Netmask/{print$2}')
#  echo "$NETMASK"
#}

function get_netmask() {
  local IP
  local IP_ARRAY
  local MASK
  local masks=( "0.0.0.0" "128.0.0.0" "192.0.0.0"
                "224.0.0.0" "240.0.0.0" "248.0.0.0"
                "252.0.0.0" "254.0.0.0" "255.0.0.0"
                "255.128.0.0" "255.192.0.0" "255.224.0.0"
                "255.240.0.0" "255.248.0.0" "255.252.0.0"
                "255.254.0.0" "255.255.0.0" "255.255.128.0"
                "255.255.192.0"  "255.255.224.0" "255.255.240.0"
                "255.255.248.0" "255.255.252.0"  "255.255.254.0"
                "255.255.255.0"  "255.255.255.128"  "255.255.255.192"
                "255.255.255.224" "255.255.255.240" "255.255.255.248"
                "255.255.255.252" "255.255.255.254"  "255.255.255.255" )

  IP="$(get_all_ip)"
  IFS=$'\n' read -ra IP_ARRAY <<< "$IP"
  MASK="$(echo ${IP_ARRAY[0]} | awk -F '/' '{print $2}')"

  if [[ $MASK -ge 0 && $MASK -le 32 ]]
  then
    echo ${masks[$MASK]}
  fi
}

function get_gateway() {
  GATEWAY=$(ip route list | awk '/default/{print$3}')

  echo "$GATEWAY"
}

function get_ram_info() {
  local MEM_INFO="$(free -b | grep Mem)"
  local RAM_TOTAL_B=$(echo $MEM_INFO | awk '{print$2}')
  local RAM_USED_B=$(echo "$MEM_INFO" | awk '{print$3}')
  local RAM_FREE_B=$(echo "$MEM_INFO" | awk '{print$4}')
  local RAM_TOTAL=$(echo "scale = 3; $RAM_TOTAL_B / 1000.0 / 1000.0 / 1000.0" | \
                    bc | awk '{printf "%.3f", $0}')
  local RAM_USED=$(echo "scale = 3; $RAM_USED_B / 1000.0 / 1000.0 / 1000.0" | \
                   bc | awk '{printf "%.3f", $0}')
  local RAM_FREE=$(echo "scale = 3; $RAM_FREE_B / 1000.0 / 1000.0 / 1000.0" | \
                   bc | awk '{printf "%.3f", $0}')

  echo "$RAM_TOTAL GB;$RAM_USED GB;$RAM_FREE GB"
}

function get_space_info() {
  local DF_INFO="$(df --block-size=1 '/' | grep '/')"
  local SPACE_ROOT_B=$(echo "$DF_INFO" | awk '{print$2}')
  local SPACE_ROOT_USED_B=$(echo "$DF_INFO" | awk '{print$3}')
  local SPACE_ROOT_FREE_B=$(echo "$DF_INFO" | awk '{print$4}')
  local SPACE_ROOT=$(echo "scale = 2; $SPACE_ROOT_B / 1000.0 / 1000.0" | \
                     bc | awk '{printf "%.2f", $0}')
  local SPACE_ROOT_USED=$(echo "scale = 2; $SPACE_ROOT_USED_B / 1000.0 / 1000.0" | \
                          bc | awk '{printf "%.2f", $0}')
  local SPACE_ROOT_FREE=$(echo "scale = 2; $SPACE_ROOT_FREE_B / 1000.0 / 1000.0" | \
                          bc | awk '{printf "%.2f", $0}')

  echo "$SPACE_ROOT MB;$SPACE_ROOT_USED MB;$SPACE_ROOT_FREE MB"
}

