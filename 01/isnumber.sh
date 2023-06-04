
function isnumber() {
if [[ "$1" =~ ^[[:space:]]*[-+]?[0-9]+\.?[0-9]*[eE]?[-+]?[0-9]*[[:space:]]*$ ]]; then
  return 1
else
  return 0
fi
}

