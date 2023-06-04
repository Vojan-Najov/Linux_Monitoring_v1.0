
function print_settings() {
  DEFAULT_SETTINGS=$1
  COLORS=( $2 $3 $4 $5 )
  COLOR_TAGS=( "default" "default" "default" "default" )

  if [ $DEFAULT_SETTINGS -eq 0 ]
  then
    for (( i=0; i < 4; ++i ))
    do
      case "${COLORS[$i]}" in
        "white")  COLOR_TAGS[$i]=1;;
        "red")    COLOR_TAGS[$i]=2;;
        "green")  COLOR_TAGS[$i]=3;;
        "blue")   COLOR_TAGS[$i]=4;;
        "purple") COLOR_TAGS[$i]=5;;
        "black")  COLOR_TAGS[$i]=6;;
      esac
    done
  fi

  printf "Column 1 background = %s (%s)\n" "${COLOR_TAGS[0]}" "${COLORS[0]}"
  printf "Column 1 font color = %s (%s)\n" "${COLOR_TAGS[1]}" "${COLORS[1]}"
  printf "Column 2 background = %s (%s)\n" "${COLOR_TAGS[2]}" "${COLORS[2]}"
  printf "Column 2 font color = %s (%s)\n" "${COLOR_TAGS[3]}" "${COLORS[3]}"
}

