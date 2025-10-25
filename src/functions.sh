
fns_convert() {

  local input="$1"

  local enToRu
  declare -A enToRu=(
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

    ['?']="," ['/']="." ['&']="?" ['^']=":" ['$']=";" ['#']="№" ['@']='"'
  )

  local ruToEn
  declare -A ruToEn=(
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

    [","]="?" ["№"]="#"
  )

  local fromTo
  fromTo="$(xset -q | grep "Group 2" | awk '{print $4}' | sed 's/on/ruToEn/g; s/off/enToRu/g')"

  local output=""
  local newChar
  local i=0
  for (( ; i<${#input}; i++ )); do
    local char="${input:$i:1}"

    if [[ "$fromTo" == "enToRu" && -n "${enToRu[$char]}" ]]; then
        newChar="${enToRu[$char]}"
    elif [[ "$fromTo" == "ruToEn" && -n "${ruToEn[$char]}" ]]; then
        newChar="${ruToEn[$char]}"
    else
        newChar="$char"
    fi

    output+="$newChar"
  done

  echo "$output"
}

fns_get_terminal_processed_string() {

  local string="$1"

  local stringExplode
  IFS=' ' read -ra stringExplode <<< "$string"

  unset 'stringExplode[0]'
  echo "$(IFS=' '; echo "${stringExplode[*]}")"
}

fns_get_processed_string() {

  local input_string="$1"

  fns_get_processed_string_result_1=""
  fns_get_processed_string_result_2=""

  local string_split=()
  local len=${#input_string}

  for ((i=len-1; i>=0; i--)); do
    string_split+=("${input_string:$i:1}")
  done

  local part1=()
  local part2=()
  local isset_letter=false
  local is_part1=false

  for char in "${string_split[@]}"; do
    if [[ "$char" != " " ]]; then
      isset_letter=true
    fi

    if [[ "$is_part1" == true ]]; then
      part1+=("$char")
    else
      part2+=("$char")
    fi

    if [[ "$isset_letter" == true && "$char" == " " ]]; then
      is_part1=true
    fi
  done

  local reversed_part1=()
  local reversed_part2=()

  for ((i=${#part1[@]}-1; i>=0; i--)); do
    reversed_part1+=("${part1[i]}")
  done

  for ((i=${#part2[@]}-1; i>=0; i--)); do
    reversed_part2+=("${part2[i]}")
  done

  for char in "${reversed_part1[@]}"; do
    fns_get_processed_string_result_1+="$char"
  done

  for char in "${reversed_part2[@]}"; do
    fns_get_processed_string_result_2+="$char"
  done
}

fns_switch_last() {

  local win_class
  win_class=$(xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}')

  if [[ "$win_class" == "Gnome-terminal" ]]; then
    fns_switch_last_gnome_terminal
  else
    fns_switch_last_common
  fi

  xdotool key Mode_switch
}

fns_switch_last_gnome_terminal() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  xte 'keydown Control_L' 'keydown Shift_L' 'key f' 'keyup Shift_L' 'keyup Control_L'
  sleep 0.2

  echo -n ".*" | xsel -ib
  xte 'keydown Control_L' 'key v' 'keyup Control_L'

  xte 'key Tab' 'key Tab' 'key Tab' 'key space' 'key Return' 'key Escape'
  sleep 0.5
  xte 'keydown Control_L' 'keydown Shift_L' 'key c' 'keyup Shift_L' 'keyup Control_L'

  fns_get_processed_string "$(fns_get_terminal_processed_string "$(xsel -ob)")"
  echo -n "$fns_get_processed_string_result_1$(fns_convert "$fns_get_processed_string_result_2")" | xsel -ib
  xte 'keydown Control_L' 'key u' 'keyup Control_L' \
    'keydown Control_L' 'keydown Shift_L' 'key v' 'keyup Shift_L' 'keyup Control_L'
  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_last_common() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  xte 'keydown Shift_L' 'key Home' 'keyup Shift_L'
  sleep 0.00000001
  xte 'keydown Shift_L' 'key Home' 'keyup Shift_L'
  sleep 0.00000001
  xte 'keydown Control_L' 'key x' 'keyup Control_L'
  sleep 0.2

  fns_get_processed_string "$(xsel -ob)"
  echo -n "~$fns_get_processed_string_result_1$(fns_convert "$fns_get_processed_string_result_2")~" | xsel -ib
  xte 'keydown Control_L' 'key v' 'keyup Control_L'
  sleep 0.2
  xte 'key BackSpace'
  sleep 0.01
  xte 'key Home'
  sleep 0.05
  xte 'key Delete'
  sleep 0.01
  xte 'key End'
  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib
}

fns_switch_selected() {

  local saved_clipboard
  saved_clipboard=$(xsel -ob)

  sleep 0.2
  xte 'keydown Control_L' 'key c' 'keyup Control_L'
  sleep 0.2
  echo -n "$(fns_convert "$(xsel -ob)")" | xsel -ib
  sleep 0.2
  xte 'keydown Control_L' 'key v' 'keyup Control_L'
  sleep 0.2

  echo -n "$saved_clipboard" | xsel -ib

  xdotool key Mode_switch
}
