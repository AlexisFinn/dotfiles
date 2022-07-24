#!/usr/bin/env bash
backends=("haishoku" "wal" "schemer2" "colorz" "colorthief")
echo Choose your backend: 0/haishoku 1/wal 2/schemer2 3/colorz 4/colorthief
read -p "[0]: " backend
backend=${backends[$backend]}
echo $backend

wpg --backend $backend -s "$@"
# xmonad
#cp ~/.config/wpg/templates/Colors.hs ~/.xmonad/lib/Colors.hs
# zsh
mkdir -p ~/.cache/wpg
cp ~/.config/wpg/templates/sequences ~/.cache/wpg/
cp ~/.config/wpg/templates/colors-rofi-dark.rasi ~/.cache/wpg/
# probably useless
# backend=&{backend:-0}
