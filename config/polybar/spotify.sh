#!/usr/bin/env bash

# Streams the current Spotify track for polybar's custom/script module (tail = true).

player="${SPOTIFY_PLAYER:-spotify}"

playerctl -p "$player" metadata --follow \
    --format '{{artist}} — {{title}}' 2>/dev/null |
    while IFS= read -r line; do
        status=$(playerctl -p "$player" status 2>/dev/null)
        if [[ "$status" == "Playing" ]]; then
            echo " $line"
        elif [[ "$status" == "Paused" ]]; then
            echo " $line"
        else
            echo ""
        fi
    done
