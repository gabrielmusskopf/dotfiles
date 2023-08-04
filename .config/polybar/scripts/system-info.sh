#!/bin/bash

head=$(neofetch --stdout | head -n 1)
infos=$(neofetch --stdout | tail -n +3 | awk '{sub($1, "<b>"$1"</b>")} 1')
#logo=$(neofetch -L --ascii_colors 0  --colors 0 | sed 's/\x1b\[[0-9;]*m//g')

notify-send "$head" "$infos\n"
