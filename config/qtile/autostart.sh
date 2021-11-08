#! /bin/bash
# set screen resolution and orientation
/home/alexis/bin/setArandr.sh &
# wallpaper and colors
wal -R &
# composition
picom --experimental-backends --blur-method dual_kawase &
# notification
dunst &
# dispable touchpad if mouse is detected
touchpad-indicator &
