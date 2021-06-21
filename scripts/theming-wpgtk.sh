#!/usr/bin/env bash
wpg -s "$@"
# xmonad
cp ~/.config/wpg/templates/Colors.hs ~/.xmonad/lib/Colors.hs
# zsh
mkdir -p ~/.zshrc.exstras && cp ~/.config/wpg/templates/sequences "$_"
