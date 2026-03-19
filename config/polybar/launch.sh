#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit 2>/dev/null

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Launch polybar on each monitor
for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar main &disown
done
