
[Read in English](https://github.com/mizuhomizuho/punto-switcher-for-linux/#punto-switcher-for-linux) ↓

# Punto Switcher для Linux

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/logo.png" alt="">

---

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v1.gif" alt="">
<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v3.gif" alt="">
<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v2.gif" alt="">

## Что умеет скрипт?

1) Конвертировать последнее слово **перед курсором**.
2) Конвертировать выделенное.
3) Конвертировать **последнее слово** в строке терминала Gnome.
4) Конвертировать выделенное в строке терминала Gnome.
5) Назначать отдельные сочетания клавиш для переключения на каждую из раскладок.

Направление конвертации (`ru_to_us` или `us_to_ru`) и менять ли раскладку после, определяется автоматически.
Зависит от количества совпадений с раскладкой в конвертируемом слове,
если это не удалось определить, то от текущей раскладки.

Всего должно быть 2 раскладки (но легко переделать и под более, чем 2).
Все соответствия настраиваются в `ru_to_us` и `us_to_ru` в `src/functions.sh`.
Даже **не важно** какие 2 раскладки у Вас в системе...
В `ru_to_us` и `us_to_ru` можно настроить любые 2.

## Важно понимать:

Скрипт работает на `x11`. Проверяем:

```shell
echo $XDG_SESSION_TYPE
```

Переключиться на `x11` сейчас можно при входе в систему. Например, в Ubuntu:

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4.png" alt="">

Если выводит `wayland`, работать не будет...

**Как правило - все ок**, но:

Скрипт (или часть логики) может не заработать даже если у Вас, как и у меня - Linux Mint 22.1 Cinnamon...

По сути скрипт делает то, что Вы сами сделали бы нажатиями клавиш, т.е. - автоматизацию...

В `src/functions.sh` много пауз (`sleep`) значения которых, как мне кажется, **могут** быть у Вас немного другими.

Значения пауз зависит от конкретного железа, драйверов, ПО или когда компьютер подвисает...

По этому, сразу наберитесь сил и терпения т.к., возможно, придется лезть в код, если с ходу не заработает.

Далее я попробую описать так, чтоб Вам было как можно легче все настроить и разобраться...

## 1) Установка утилит:

```bash
sudo apt install -y xautomation # xte
sudo apt install -y xsel xdotool xbindkeys
```

## 2) Установка прав на выполнение:

```bash
cd ./punto_switcher  
chmod u=rwx,g=rwx,o=rx ./switch_last.sh
chmod u=rwx,g=rwx,o=rx ./switch_select.sh
```

## 3) Настройка горячих клавиш:

Сочетания клавиш, для работы скриптов, нужно указывать именно через `xbindkeys`.
Т.к. в `xbindkeys` можно указать тип события "Release", т.е., когда все клавиши были отпущены.
Иначе, работать точно не будет. Отпускать клавиши надо в обратном порядке. Сначала `z`, а потом остальные.

### Добавляем в конец `~/.xbindkeysrc` (если нету, то нужно создать):

Меняем `~/my_soft_path` на свой путь до папки `punto_switcher`.

```text
"~/my_soft_path/punto_switcher/switch_last.sh"
Release + Pause

"~/my_soft_path/punto_switcher/switch_select.sh"
Release + Control + Alt + z
   ```

### Можно выбрать свои свободные комбинации клавиш:

Важно понимать, что комбинации клавиш, такие как, например Control + Alt (без дополнительной клавиши),
считаются **модификаторами**. Их назначить через `xbindkeys` (как и через аналог `sxhkd`) не получиться...

- У меня `Pause` (Fn + p) - для конвертации последнего слова.
- И `Control + Alt + z` - для конвертации выделенного текста.

Можно посмотреть `xbindkeys --defaults`, там есть примеры и описание:

```bash
xbindkeys --defaults
```

Возможно Вам пригодится еще это (после запуска будет инструкция, о том, что нужно делать):

```bash
xbindkeys --key
```

### Перезапускаем `xbindkeys`:

```bash
killall xbindkeys
xbindkeys
```

## 4) Возможно, у Вас еще нужно будет поменять:
`"s/on/ru/g; s/off/us/g"` на `"s/on/us/g; s/off/ru/g"` в `src/functions.sh`...

## 5) Назначение отдельных сочетания клавиш для переключения на каждую из раскладок:

Назначить клавиши, можно через GUI в Вашей ОС.
Но у меня, иногда они не срабатывали, хотя нажатия клавиш были, если смотреть по `xinput test <ID клавиатуры>`.
Скорее всего, это проблема в моей ОС... Если у Вас все в порядке, то просто назначьте клавиши для этих команд:

```bash
~/my_soft_path/punto_switcher/switch_layout.sh us
~/my_soft_path/punto_switcher/switch_layout.sh ru
```

Меняем `~/my_soft_path` на свой путь до папки `punto_switcher`.

### Если как и у меня, иногда не срабатывают, назначенные через GUI сочетания:

Если хотите использовать сочетания **не модификаторы**, то опять же подойдет `xbindkeys`.
Просто добавьте те команды через него... `xbindkeys`, как и его аналог `sxhkd`, не работает с модификаторами.
По этому, если Вы хотите модификаторы, то Вам нужно добавить в `~/.profile` демона:

```bash
if [ -f ~/my_soft_path/punto_switcher/switch_layout.sh ]; then
    ~/my_soft_path/punto_switcher/switch_layout.sh daemon &
fi
```

Меняем `~/my_soft_path` на свой путь до папки `punto_switcher`. Но сперва демона нужно будет настроить...

В `switch_layout.sh` нужно указать:

```bash
cfg_keyboard_id=14
cfg_combo_key_us_1="Super_L"
cfg_combo_key_us_2="Shift_L"
cfg_combo_key_ru_1="Super_L"
cfg_combo_key_ru_2="Control_L"
```

Как указать `cfg_keyboard_id` можно почитав "Как посмотреть список устройств ввода?"
и "Как посмотреть события нажатия клавиш?" ниже. Если Вы хотите настроить свои сочетания клавиш,
посмотрите "Как посмотреть коды и названия клавиш?".
Вообще, я выбрал именно эти сочетания, по разным причинам. У меня эти клавиши находятся рядом.
И они, являются единственными свободными сочетаниями-модификаторами, которые больше не используются ни в каких программах.

Установите права на выполнение:

```bash
cd ./punto_switcher  
chmod u=rwx,g=rwx,o=rx ./switch_layout.sh
```

## 6) Если нет нужного результата (не работает):

Если Вы уже пользуетесь этим скриптом и заметили, что что-то плохо работает,
то проверьте ID последнего комита, возможно стоит обновиться. Иначе, нужно будет заняться отладкой.

На всякий случай -> [Что такое отладка?](https://ru.wikipedia.org/wiki/%D0%9E%D1%82%D0%BB%D0%B0%D0%B4%D0%BA%D0%B0_%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B)

Скрипты можно запускать в консоли и (или) делать вывод результатов в файл.

1) Стоит обратить внимание на значения пауз (`sleep`) в коде.
Возможно, нужно будет увеличивать время пауз или добавлять новые.
2) Соответствия символов можно переопределить в `us_to_ru` и `ru_to_us`.

Все делается в `src/functions.sh`.

## 7) Что возможно пригодится?

### Как посмотреть список устройств ввода?

   ```bash
   xinput list
   ```

   В моем случае клавиатура, оказалось с ID 14...

   <img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s1.png" alt="">

### Как посмотреть события нажатия клавиш?

   14 - это ID **моей** клавиатуры. Свой ID, можно поискать так: `xinput list`.
   Если ID верный, мы будем видеть подобное, нажимая на клавиши.

   ```bash
   xinput test 14
   ```

   <img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s2.png" alt="">

### Как посмотреть коды и названия клавиш?

   ```bash
   xmodmap -pke
   ```

   <img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s3.png" alt="">

### Для настройки конвертации в терминале (Gnome terminal):

   Смотрим что выводит:

   ```bash
   xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}'
   ```

   Если команда, выполненная в активном окне Gnome terminal, выводит не `"Gnome-terminal"`,
   то найдите в `src/functions.sh` `"Gnome-terminal"` и исправьте на нужное значение.

### Вся логика тут:

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4_4.png" alt="">

---

⭐ И поставь, пожалуйста, звезду, если скрипт в помощь =)

Далее, то же самое, но на английском...

---

# Punto Switcher for Linux

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/logo.png" alt="">  

---

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v1.gif" alt="">  
<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v3.gif" alt="">  
<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/v2.gif" alt="">  

## What does the script do?

1. Converts the **last word before the cursor**.
2. Converts the selected text.
3. Converts the **last word** in a Gnome terminal line.
4. Converts the selected text in a Gnome terminal line.
5. Allows assigning separate hotkeys for switching to each layout.

The conversion direction (`ru_to_us` or `us_to_ru`) and whether to switch the layout afterward are determined automatically.
It depends on the number of matches with the keyboard layout in the converted word;
if it cannot be determined, the current layout is used.

There should be two layouts (but it’s easy to adapt for more).
All mappings are configured in `ru_to_us` and `us_to_ru` in `src/functions.sh`.
It doesn’t even matter which two layouts you have in your system —
you can configure any two you like.

## Important to understand:

The script works under `x11`. Check it with:

```shell
echo $XDG_SESSION_TYPE
```

You can switch to `x11` at login. For example, in Ubuntu:

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4.png" alt="">  

If it outputs `wayland`, it will not work...

**Usually, everything is fine**, but:

The script (or part of it) might fail even if you, like me, use Linux Mint 22.1 Cinnamon...

Basically, the script just automates what you could do manually with key presses.

In `src/functions.sh`, there are many pauses (`sleep`), the values of which, I believe,
might be slightly different on your system.

The pause values depend on the specific hardware, drivers, software, or when the computer freezes...

So, be patient — you might need to tweak the code if it doesn’t work right away.

Below, I’ll try to describe everything so you can set it up easily.

## 1) Install dependencies:

```bash
sudo apt install -y xautomation # xte
sudo apt install -y xsel xdotool xbindkeys
```

## 2) Set execution permissions:

```bash
cd ./punto_switcher  
chmod u=rwx,g=rwx,o=rx ./switch_last.sh
chmod u=rwx,g=rwx,o=rx ./switch_select.sh
```

## 3) Configure hotkeys:

Hotkeys for the scripts must be assigned via `xbindkeys`,
because it supports the "Release" event (when all keys are released).
Otherwise, it won’t work properly.
Keys must be released in reverse order — first `z`, then the others.

### Add to the end of `~/.xbindkeysrc` (create if it doesn’t exist):

Replace `~/my_soft_path` with the path to your `punto_switcher` folder.

```text
"~/my_soft_path/punto_switcher/switch_last.sh"
Release + Pause

"~/my_soft_path/punto_switcher/switch_select.sh"
Release + Control + Alt + z
```

### You can choose your own hotkey combinations:

Keep in mind that combinations like Control + Alt (without an additional key)
are considered **modifiers** and cannot be assigned in `xbindkeys` (or `sxhkd`).

* I use `Pause` (Fn + p) for converting the last word.
* And `Control + Alt + z` for converting the selected text.

You can view examples with:

```bash
xbindkeys --defaults
```

You can also test keys interactively:

```bash
xbindkeys --key
```

### Restart `xbindkeys`:

```bash
killall xbindkeys
xbindkeys
```

## 4) You might also need to change:

`"s/on/ru/g; s/off/us/g"` → `"s/on/us/g; s/off/ru/g"` in `src/functions.sh`.

## 5) Assign separate hotkeys for switching layouts:

You can assign layout switch keys through your OS GUI.
However, sometimes they may not work even if `xinput test <keyboard ID>` shows the keypresses —
likely a system-specific issue.

If everything works fine, just assign hotkeys for these commands:

```bash
~/my_soft_path/punto_switcher/switch_layout.sh us
~/my_soft_path/punto_switcher/switch_layout.sh ru
```

Replace `~/my_soft_path` with your actual path.

### If GUI hotkeys sometimes don’t work:

If you want to use **non-modifier** key combos, again use `xbindkeys`.
If you need **modifiers**, add a daemon to `~/.profile`:

```bash
if [ -f ~/my_soft_path/punto_switcher/switch_layout.sh ]; then
    ~/my_soft_path/punto_switcher/switch_layout.sh daemon &
fi
```

Change `~/my_soft_path` to your path to the `punto_switcher` folder.
But first, you will need to configure the daemon...

In `switch_layout.sh` you need to specify:

```bash
cfg_keyboard_id=14
cfg_combo_key_us_1="Super_L"
cfg_combo_key_us_2="Shift_L"
cfg_combo_key_ru_1="Super_L"
cfg_combo_key_ru_2="Control_L"
```

You can find out how to set `cfg_keyboard_id` by reading the sections “How to view the list of input devices?”
and “How to view key press events?” below.
If you want custom key combos, see “How to view key codes and names?”.
In general, I chose these combinations for several reasons.
These keys are located close to each other,
and they are the only free modifier combinations that aren’t used by any other programs.

Set execution permissions:

```bash
cd ./punto_switcher  
chmod u=rwx,g=rwx,o=rx ./switch_layout.sh
```

## 6) If it doesn’t work:

If you’re already using this script and noticed that something isn’t working properly,
check the ID of the latest commit — it might be worth updating.
Otherwise, debugging will be needed.

For reference → [What is debugging?](https://en.wikipedia.org/wiki/Debugging)

You can run scripts in the console or redirect outputs to files.

1. Pay attention to `sleep` values — increase or add as needed.
2. You can redefine character mappings in `us_to_ru` and `ru_to_us`.

Everything is in `src/functions.sh`.

## 7) Useful commands:

### How to view the list of input devices?

```bash
xinput list
```

In my case, the keyboard ID is 14.

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s1.png" alt="">  

### How to view key press events?

```bash
xinput test 14
```

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s2.png" alt="">  

### How to view key codes and names?

```bash
xmodmap -pke
```

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s3.png" alt="">  

### Configure conversion in Gnome Terminal:

Check what it outputs:

```bash
xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}'
```

If it doesn’t output `"Gnome-terminal"`,
find `"Gnome-terminal"` in `src/functions.sh` and replace it with the correct value.

### Main logic overview:

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4_4.png" alt="">  

---

⭐ Please give it a star if you find the script useful =)

