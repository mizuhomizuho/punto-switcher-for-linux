#!/bin/bash

source "$(dirname "$0")/src/functions.sh"

cfg_keyboard_id=14

cfg_combo_key_us_1="Super_L"
cfg_combo_key_us_2="Shift_L"

cfg_combo_key_ru_1="Super_L"
cfg_combo_key_ru_2="Control_L"

fns_switch_layout "$1"
