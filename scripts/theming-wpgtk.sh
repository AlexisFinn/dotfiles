#!/usr/bin/env bash
wpg -s "$@"
# xmonad
cp ~/.config/wpg/templates/Colors.hs ~/.xmonad/lib/Colors.hs
# zsh
mkdir -p ~/.cache/wpg
cp ~/.config/wpg/templates/sequences ~/.cache/wpg/
cp ~/.config/wpg/templates/colors-rofi-dark.rasi ~/.cache/wpg/
