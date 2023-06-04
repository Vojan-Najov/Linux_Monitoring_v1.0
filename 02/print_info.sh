
function print_info {
  local RAM_INFO
  local SPACE_INFO

  echo "HOSTNAME = $(get_hostname)"
  echo "TIMEZONE = $(get_timezone)"
  echo "USER = $USER"
  echo "OS = $(get_os)"
  echo "DATE = $(get_date)"
  echo "UPTIME = $(get_uptime)"
  echo "UPTIME_SEC = $(get_uptime_sec)"
  echo "IP = $(get_ip)"
  echo "MASK = $(get_netmask)"
  echo "GATEWAY = $(get_gateway)"
  IFS=$';' read -ra RAM_INFO <<<"$(get_ram_info)"
  echo "RAM_TOTAL = ${RAM_INFO[0]}"
  echo "RAM_USED = ${RAM_INFO[1]}"
  echo "RAM_FREE = ${RAM_INFO[2]}"
  IFS=';' read -ra SPACE_INFO <<< "$(get_space_info)"
  echo "SPACE_ROOT_TOTAL = ${SPACE_INFO[0]}"
  echo "SPACE_ROOT_USED = ${SPACE_INFO[1]}"
  echo "SPACE_ROOT_FREE = ${SPACE_INFO[2]}"
}

