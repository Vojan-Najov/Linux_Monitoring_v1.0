
function byte_converter() {
  local n=$1
  local uom="B"

  if [ $(echo "$n > 1000.0" | bc) -eq 1 ]; then
    n=$(echo "scale = 2; $n / 1000.0" | bc)
    uom="KB"
  fi
  if [ $(echo "$n > 1000.0" | bc) -eq 1 ]; then
    n=$(echo "scale = 2; $n / 1000.0" | bc)
    uom="MB"
  fi
  if [ $(echo "$n > 1000.0" | bc) -eq 1 ]; then
    n=$(echo "scale = 2; $n / 1000.0" | bc)
    uom="GB"
  fi
  if [ $(echo "$n > 1000.0" | bc) -eq 1 ]; then
    n=$(echo "scale = 2; $n / 1000.0" | bc)
    uom="TB"
  fi

  printf "%s %s\n" "$n" "$uom"
}

