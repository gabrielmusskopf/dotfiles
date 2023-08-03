#!/usr/bin/env bash

# Add this script to your wm startup file.
# sudo ln -s ~/.config/polybar/launch.sh /etc/init.d/polybar.sh

DIR="$HOME/.config/polybar/"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q top -c "$DIR"/config.ini 2>/tmp/polybar-top.log &
polybar -q bottom -c "$DIR"/config.ini 2>/tmp/polybar-bottom.log  &

echo "polybar lauched"
