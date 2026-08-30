#!/bin/sh

WALLDIR="$HOME/Pictures/wallpapers"

WALLPAPER=$(find "$WALLDIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) |
    shuf -n 1)

[ -z "$WALLPAPER" ] && exit 1

feh --bg-fill "$WALLPAPER"
