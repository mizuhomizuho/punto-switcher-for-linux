
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

Направление конвертации (`ru_to_us` или `us_to_ru`) и менять ли раскладку после, определяется автоматически.
Зависит от количества совпадений с раскладкой в конвертируемом слове,
если это не удалось определить, то от текущй раскладки.

Всего должно быть 2 раскладки (но легко переделать и под более, чем 2).
Все соответствия настраиваются в `ru_to_us` и `us_to_ru` в `src/functions.sh`.
Даже **не важно** какие 2 раскладки у Вас в системе...
В `ru_to_us` и `us_to_ru` можно настроить любые 2.

## Важно понимать:

Скрипт работает на `x11`. Проверяем:

```shell
echo $XDG_SESSION_TYPE
```

Переключиться на `x11` сейчас можно при входе в систему. Если выводит `wayland`, работать не будет...

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4.png" alt="">

**Как правило - все ок**, но:

Скрипт (или часть логики) может не заработать даже если у Вас, как и у меня - Linux Mint 22.1 Cinnamon...

По сути скрипт делает то, что Вы сами сделали бы нажатиями клавиш, т.е. - автоматизацию...

В `src/functions.sh` много пауз (`sleep`) значения которых, как мне кажется, **могут** быть у Вас немного другими.

Значения пауз зависит от конкретного железа, драйверов, ПО и т.д.

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

Сочетания клавиш, для работы скриптов, нужно указывать именно через xbindkeys.
Т.к. в xbindkeys можно указать тип события "Release", т.е. когда все клавиши были отпущены.
Иначе, работать точно не будет. Отпускать клавиши надо в обратном порядке. Сначала `z`, а потом остальные.

1) Добавляем в конец ~/.xbindkeysrc (если нету, то нужно создать):
   ```text
   "~/my_soft_path/punto_switcher/switch_last.sh"
   Release + Pause
   
   "~/my_soft_path/punto_switcher/switch_select.sh"
   Release + Control + Alt + z
   ```
2) Меняем `~/my_soft_path` на свой путь до папки `punto_switcher`.

3) Можно выбрать свои свободные комбинации клавиш:

   - У меня это `Pause` - для конвертации последнего слова.
   - И `Control + Alt + z` - для выделенного текста.

   Можно посмотреть "xbindkeys --defaults", там есть примеры и описание:
   ```text
   xbindkeys --defaults
   ```

4) Перезапускаем xbindkeys:
   ```bash
   killall xbindkeys
   xbindkeys
   ```

## 4) Возможно, у Вас еще нужно будет поменять:
`"s/on/ru_lng/g; s/off/us_lng/g"` на `"s/on/us_lng/g; s/off/ru_lng/g"` в `src/functions.sh`...

## 5) Если нет нужного результата (не работает):

Если Вы уже пользуетесь этим скриптом и заметили, что что-то плохо работает,
то проверьте обновления репозитория, возможно стоит обновиться. Иначе, нужно будет заняться отладкой.

На всякий случай -> [Что такое отладка?](https://ru.wikipedia.org/wiki/%D0%9E%D1%82%D0%BB%D0%B0%D0%B4%D0%BA%D0%B0_%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B)

Скрипты можно запускать в консоли и (или) делать вывод результатов в файл.

1) Стоит обратить внимание на значения пауз (`sleep`) в коде.
Возможно, нужно будет увеличивать время пауз или добавлять новые.
2) Соответствия символов можно переопределить в `us_to_ru` и `ru_to_us`.

Все делается в `src/functions.sh`.

## 6) Что возможно пригодится?

### Тут находим ID своей клавиатуры:

   В моем случае это оказалось 14... Как определить свой ID смори далее.

   ```bash
   xinput list
   ```
   <img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s1.png" alt="">

### Тут будет видно нажатия клавиш, их числовой код:

   ```bash
   xinput test 14
   ```
   
   Если ID верный, мы будем видеть подобное, нажимая на клавиши:

   <img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s2.png" alt="">

### Тут будет видно все клавиши, их коды и названия:

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

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4_3.png" alt="">

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

## What the script can do

1. Convert the last word **before the cursor**.
2. Convert the selected text.
3. Convert the **last word** in a Gnome Terminal line.
4. Convert the selected text inside a Gnome Terminal line.

The conversion direction (`ru_to_us` or `us_to_ru`) 
and whether to switch the keyboard layout afterward are determined automatically.
It depends on how many characters in the word match each layout; if it cannot be determined,
the current layout is used.


There should be only 2 layouts (but it’s easy to modify for more than 2).
All key mappings are configurable in `ru_to_us` and `us_to_ru` inside `src/functions.sh`.
It **doesn’t even matter** which two layouts you have in your system...
You can configure any two in `ru_to_us` and `us_to_ru`.

---

## Important to understand

The script runs on `x11`. Check it with:

```shell
echo $XDG_SESSION_TYPE
```

You can switch to `x11` when logging into the system. If it outputs `wayland`, it won’t work...

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4.png" alt="">

**As a rule — everything is fine**, but:

The script (or part of its logic) may not work immediately, even if you are using Linux Mint 22.1 Cinnamon like me…

Essentially, the script automates what you would normally do by pressing keys manually.

There are many pauses (`sleep`) in `src/functions.sh`. Their values **may** need adjustment depending on your system.

Pause durations depend on your specific hardware, drivers, software, etc.

So, be patient, as you might need to dive into the code if it doesn’t work out-of-the-box.

I will try to describe everything in a way that makes it as easy as possible to set up and understand.

---

## 1) Installing utilities

```bash
sudo apt install -y xautomation # xte
sudo apt install -y xsel xdotool xbindkeys
```

---

## 2) Setting execution permissions

```bash
cd ./punto_switcher
chmod u=rwx,g=rwx,o=rx ./switch_last.sh
chmod u=rwx,g=rwx,o=rx ./switch_select.sh
```

---

## 3) Configuring hotkeys

Hotkeys must be configured via **xbindkeys**, because xbindkeys allows specifying the **Release** event, i.e., when all keys are released.
Otherwise, the scripts will not work reliably. You need to release the keys in reverse order — first `z`, then the others.

1. Add to the end of `~/.xbindkeysrc` (create if it doesn’t exist):

```text
"~/my_soft_path/punto_switcher/switch_last.sh"
Release + Pause

"~/my_soft_path/punto_switcher/switch_select.sh"
Release + Control + Alt + z
```

2. Replace `~/my_soft_path` with your path to the `punto_switcher` folder.

3. You can choose your own free key combinations:

* I use `Pause` for converting the last word.
* And `Control + Alt + z` for converting selected text.

You can see examples and descriptions with:

```text
xbindkeys --defaults
```

4. Restart xbindkeys:

```bash
killall xbindkeys
xbindkeys
```

## 4) You might also need to change:
`"s/on/ru_lng/g; s/off/us_lng/g"` to `"s/on/us_lng/g; s/off/ru_lng/g"` in `src/functions.sh`…

---

## 5) If the desired result is not achieved (doesn’t work):

If you are already using this script and notice that something isn’t working properly,
please check the repository for updates — you might need to update. Otherwise, you will need to do some debugging.

For reference → [What is debugging?](https://en.wikipedia.org/wiki/Debugging)

Scripts can be run in the console and/or their output redirected to a file.

1. Pay attention to the `sleep` values in the code. You may need to increase the pauses or add new ones.
2. You might need to adjust the order of key press emulation, or even the key names.
3. Key mappings can be redefined in `us_to_ru` and `ru_to_us`.

All of this is done in `src/functions.sh`.

---

## 6) Useful tips

### Finding your keyboard ID

In my case, it was `14`. See below to determine your own ID:

```bash
xinput list
```

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s1.png" alt="">

---

### Check key presses and their numeric codes

```bash
xinput test 14
```

If the ID is correct, pressing keys will produce output like this:

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s2.png" alt="">

---

### See all keys, their codes, and names

```bash
xmodmap -pke
```

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s3.png" alt="">

---

### To configure conversion in the terminal (Gnome Terminal):

Check what this returns:

```bash
xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}'
```

If it doesn’t return `"Gnome-terminal"` for the active window, find `"Gnome-terminal"` in `src/functions.sh` and replace it with the correct value.

---

### Logic overview

<img src="https://github.com/mizuhomizuho/punto-switcher-for-linux/blob/main/images/s4_3.png" alt="">

---

⭐ Please give a star if this script helps you =)
