
function isnumber() {
if [[ $# -eq 1 && "$1" =~ ^[-+]?[0-9]+\.?[0-9]*[eE]?[-+]?[0-9]*$ ]]; then
  return 1
else
  return 0
fi
}

