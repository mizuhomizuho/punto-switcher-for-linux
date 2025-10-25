
fns_convert() {

  local input="$1"

  fns_convert_result_output=""
  fns_convert_result_switch=false

  local us_to_ru
  declare -A us_to_ru=(
    ["q"]="й" ["w"]="ц" ["e"]="у" ["r"]="к" ["t"]="е"
    ["y"]="н" ["u"]="г" ["i"]="ш" ["o"]="щ" ["p"]="з"
    ["["]="х" ["]"]="ъ" ["a"]="ф" ["s"]="ы" ["d"]="в"
    ["f"]="а" ["g"]="п" ["h"]="р" ["j"]="о" ["k"]="л" ["l"]="д"
    [";"]="ж" ["'"]="э" ["z"]="я" ["x"]="ч" ["c"]="с" ["v"]="м"
    ["b"]="и" ["n"]="т" ["m"]="ь" [","]="б" ["."]="ю" ['`']="ё"

    ["Q"]="Й" ["W"]="Ц" ["E"]="У" ["R"]="К" ["T"]="Е"
    ["Y"]="Н" ["U"]="Г" ["I"]="Ш" ["O"]="Щ" ["P"]="З"
    ["{"]="Х" ["}"]="Ъ" ["A"]="Ф" ["S"]="Ы" ["D"]="В"
    ["F"]="А" ["G"]="П" ["H"]="Р" ["J"]="О" ["K"]="Л" ["L"]="Д"
    [":"]="Ж" ['"']="Э" ["Z"]="Я" ["X"]="Ч" ["C"]="С" ["V"]="М"
    ["B"]="И" ["N"]="Т" ["M"]="Ь" ["<"]="Б" [">"]="Ю" ["~"]="Ё"

    ["?"]="," ["/"]="." ["&"]="?" ["^"]=":" ["$"]=";" ["#"]="№" ["@"]='"'
  )

  local ru_to_us
  declare -A ru_to_us=(
    ["й"]="q" ["ц"]="w" ["у"]="e" ["к"]="r" ["е"]="t"
    ["н"]="y" ["г"]="u" ["ш"]="i" ["щ"]="o" ["з"]="p"
    ["х"]="[" ["ъ"]="]" ["ф"]="a" ["ы"]="s" ["в"]="d"
    ["а"]="f" ["п"]="g" ["р"]="h" ["о"]="j" ["л"]="k" ["д"]="l"
    ["ж"]=";" ["э"]="'" ["я"]="z" ["ч"]="x" ["с"]="c" ["м"]="v"
    ["и"]="b" ["т"]="n" ["ь"]="m" ["б"]="," ["ю"]="." ["ё"]='`'

    ["Й"]="Q" ["Ц"]="W" ["У"]="E" ["К"]="R" ["Е"]="T"
    ["Н"]="Y" ["Г"]="U" ["Ш"]="I" ["Щ"]="O" ["З"]="P"
    ["Х"]="{" ["Ъ"]="}" ["Ф"]="A" ["Ы"]="S" ["В"]="D"
    ["А"]="F" ["П"]="G" ["Р"]="H" ["О"]="J" ["Л"]="K" ["Д"]="L"
    ["Ж"]=":" ["Э"]='"' ["Я"]="Z" ["Ч"]="X" ["С"]="C" ["М"]="V"
    ["И"]="B" ["Т"]="N" ["Ь"]="M" ["Б"]="<" ["Ю"]=">" ["Ё"]="~"

    [","]="?" ["№"]="#" ['"']="@"
  )

  local current_lng
  current_lng="$(fns_get_current_lng)_lng"

  local count_ru=0
  local count_us=0

  local i
  for (( i=0; i<${#input}; i++ )); do

    local char="${input:$i:1}"

    if [[ "$current_lng" == "us_lng" ]]; then
      if [[ -n "${ru_to_us[$char]}" ]]; then
        count_ru=$((count_ru + 1))
      elif [[ -n "${us_to_ru[$char]}" ]]; then
        count_us=$((count_us + 1))
      fi
    else
      if [[ -n "${us_to_ru[$char]}" ]]; then
        count_us=$((count_us + 1))
      elif [[ -n "${ru_to_us[$char]}" ]]; then
        count_ru=$((count_ru + 1))
      fi
    fi

  done

  local switch_lng_to="$current_lng"

  local new_char
  local i
  for (( i=0; i<${#input}; i++ )); do

    local char="${input:$i:1}"

    if [[ "$count_ru" -gt "$count_us" && "$count_ru" -gt 1 ]]; then
      if [[ -n "${ru_to_us[$char]}" ]]; then
          new_char="${ru_to_us[$char]}"
          switch_lng_to="us_lng"
      else
          new_char="$char"
      fi
    elif [[ "$count_us" -gt "$count_ru" && "$count_us" -gt 1 ]]; then
      if [[ -n "${us_to_ru[$char]}" ]]; then
          new_char="${us_to_ru[$char]}"
          switch_lng_to="ru_lng"
      else
          new_char="$char"
      fi
    else
      if [[ "$current_lng" == "us_lng" && -n "${us_to_ru[$char]}" ]]; then
          new_char="${us_to_ru[$char]}"
          switch_lng_to="ru_lng"
      elif [[ "$current_lng" == "ru_lng" && -n "${ru_to_us[$char]}" ]]; then
          new_char="${ru_to_us[$char]}"
          switch_lng_to="us_lng"
      else
          new_char="$char"
      fi
    fi

    fns_convert_result_output+="$new_char"

  done

  if [[ "$switch_lng_to" != "$current_lng" ]]; then
    fns_convert_result_switch=true
  fi
}

fns_switch_last() {

  if [[ "$(fns_is_gnome_terminal)" == true ]]; then
    fns_switch_last_gnome_terminal
  else
    fns_switch_last_common
  fi

  if [[ "$fns_convert_result_switch" == true ]]; then
    xdotool key Mode_switch
  fi
}

fns_switch_last_common() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  xte "keydown Shift_L" "key Home" "keyup Shift_L"
  sleep 0.05
  xte "keydown Control_L" "key c" "keyup Control_L"
  sleep 0.05

  fns_get_divided_string "$(xsel -ob)"

  fns_convert "$fns_get_divided_string_result_s2"
  echo -n "$fns_get_divided_string_result_s1$fns_convert_result_output" | xsel -ib

  xte "keydown Control_L" "key v" "keyup Control_L"
  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_last_gnome_terminal() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  fns_get_divided_string "$(fns_get_gnome_terminal_string)"
  fns_convert "$fns_get_divided_string_result_s2"
  echo -n "$fns_get_divided_string_result_s1$fns_convert_result_output" | xsel -ib
  fns_paste_to_gnome_terminal

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_selected() {

  if [[ "$(fns_is_gnome_terminal)" == true ]]; then
    fns_switch_selected_gnome_terminal
  else
    fns_switch_selected_common
  fi

  if [[ "$fns_convert_result_switch" == true ]]; then
    xdotool key Mode_switch
  fi
}

fns_switch_selected_common() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  sleep 0.15
  xte "keydown Control_L" "key c" "keyup Control_L"
  sleep 0.15
  fns_convert "$(xsel -ob)"
  echo -n "$fns_convert_result_output" | xsel -ib
  sleep 0.2
  xte "keydown Control_L" "key v" "keyup Control_L"
  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_selected_gnome_terminal() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  sleep 0.2
  xte "keydown Control_L" "keydown Shift_L" "key c" "keyup Shift_L" "keyup Control_L"
  sleep 0.2

  local for_convert
  for_convert=$(xsel -ob)

  local terminal_string
  terminal_string=$(fns_get_gnome_terminal_string true)

  fns_convert "$for_convert"

  local result
  result=${terminal_string//"$for_convert"/"$fns_convert_result_output"}

  echo -n "$result" | xsel -ib
  fns_paste_to_gnome_terminal

  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_layout() {

  local param="$1"

  if [[ "$param" == "daemon" ]]; then
    if [ -n "$DISPLAY" ]; then
      fns_switch_layout_daemon
    fi
  else
    if [[ "$param" != "$(fns_get_current_lng)" ]]; then
      xdotool key Mode_switch
    fi
  fi
}

fns_switch_layout_daemon() {

  local is_combo_key_us_1=false
  local is_combo_key_us_2=false
  local is_combo_key_ru_1=false
  local is_combo_key_ru_2=false

  local combo_key_us_1_code
  combo_key_us_1_code=$(fns_get_key_code_by_name "$cfg_combo_key_us_1")
  local combo_key_us_2_code
  combo_key_us_2_code=$(fns_get_key_code_by_name "$cfg_combo_key_us_2")
  local combo_key_ru_1_code
  combo_key_ru_1_code=$(fns_get_key_code_by_name "$cfg_combo_key_ru_1")
  local combo_key_ru_2_code
  combo_key_ru_2_code=$(fns_get_key_code_by_name "$cfg_combo_key_ru_2")

  xinput test "$cfg_keyboard_id" |
  {
    while read -r line; do

      if [[ $line =~ ^key[[:space:]]+press[[:space:]]+$combo_key_us_1_code$ ]]; then is_combo_key_us_1=true; fi
      if [[ $line =~ ^key[[:space:]]+release[[:space:]]+$combo_key_us_1_code$ ]]; then is_combo_key_us_1=false; fi

      if [[ $line =~ ^key[[:space:]]+press[[:space:]]+$combo_key_us_2_code$ ]]; then is_combo_key_us_2=true; fi
      if [[ $line =~ ^key[[:space:]]+release[[:space:]]+$combo_key_us_2_code$ ]]; then is_combo_key_us_2=false; fi

      if [[ $line =~ ^key[[:space:]]+press[[:space:]]+$combo_key_ru_1_code$ ]]; then is_combo_key_ru_1=true; fi
      if [[ $line =~ ^key[[:space:]]+release[[:space:]]+$combo_key_ru_1_code$ ]]; then is_combo_key_ru_1=false; fi

      if [[ $line =~ ^key[[:space:]]+press[[:space:]]+$combo_key_ru_2_code$ ]]; then is_combo_key_ru_2=true; fi
      if [[ $line =~ ^key[[:space:]]+release[[:space:]]+$combo_key_ru_2_code$ ]]; then is_combo_key_ru_2=false; fi

      if [[ "$is_combo_key_us_1" == true && "$is_combo_key_us_2" == true ]]; then
        fns_switch_layout "us"
      fi

      if [[ "$is_combo_key_ru_1" == true && "$is_combo_key_ru_2" == true ]]; then
        fns_switch_layout "ru"
      fi

    done
  }
}

fns_get_divided_string() {

  local input_string="$1"

  fns_get_divided_string_result_s1=""
  fns_get_divided_string_result_s2=""

  local string_split=()
  local len=${#input_string}

  local i
  for ((i=len-1; i>=0; i--)); do
    string_split+=("${input_string:$i:1}")
  done

  local part1=()
  local part2=()
  local isset_letter=false
  local is_part1=false

  local char
  for char in "${string_split[@]}"; do
    if [[ "$char" != " " ]]; then
      isset_letter=true
    fi

    if [[ "$isset_letter" == true && "$char" == " " ]]; then
      is_part1=true
    fi

    if [[ "$is_part1" == true ]]; then
      part1+=("$char")
    else
      part2+=("$char")
    fi
  done

  local reversed_part1=()
  local reversed_part2=()

  local i
  for ((i=${#part1[@]}-1; i>=0; i--)); do
    reversed_part1+=("${part1[i]}")
  done

  local i
  for ((i=${#part2[@]}-1; i>=0; i--)); do
    reversed_part2+=("${part2[i]}")
  done

  local char
  for char in "${reversed_part1[@]}"; do
    fns_get_divided_string_result_s1+="$char"
  done

  local char
  for char in "${reversed_part2[@]}"; do
    fns_get_divided_string_result_s2+="$char"
  done
}

fns_is_gnome_terminal() {

    local win_class
    win_class=$(xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}')

    local result=false
    if [[ "$win_class" == "Gnome-terminal" ]]; then
      result=true
    fi

    echo "$result"
}

fns_get_gnome_terminal_string() {

  local is_selected="$1"

  xte "keydown Control_L" "keydown Shift_L" "key f" "keyup Shift_L" "keyup Control_L"
  sleep 0.2

  xte "keydown Shift_L" "key Tab" "key Tab" "keyup Shift_L" "key space" "key Tab" "key Tab"
  echo -n ".*" | xsel -ib
  xte "keydown Control_L" "key v" "keyup Control_L"
  sleep 0.2
  xte "key Return"

  if [[ "$is_selected" == true ]]; then
    xte "key Tab" "key Tab" "key Return"
  fi

  sleep 0.3
  xte "keydown Alt_L" "key F4" "keyup Alt_L"
  sleep 0.1
  xte "keydown Control_L" "keydown Shift_L" "key c" "keyup Shift_L" "keyup Control_L"

  local string
  string="$(xsel -ob)"

  echo "${string#*":~$ "}"
}

fns_paste_to_gnome_terminal() {
    xte "key End" \
      "keydown Control_L" "key u" "keyup Control_L" \
      "keydown Control_L" "keydown Shift_L" "key v" "keyup Shift_L" "keyup Control_L"
    sleep 0.1

    xte "key Right"
}

fns_get_current_lng() {
  xset -q | grep "Group 2" | awk '{print $4}' | sed "s/on/ru/g; s/off/us/g"
}

fns_get_key_code_by_name() {

  local name="$1"

  xmodmap -pke | grep -E "keycode[[:space:]]+[0-9]+[[:space:]]+=[[:space:]]+${name}[[:space:]]" | awk '{print $2}'
}