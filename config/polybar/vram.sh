#!/usr/bin/env bash

# Reports VRAM usage for the discrete GPU (RX 9070 XT) for polybar's custom/script module.

card="/sys/class/drm/card1/device"

used=$(<"$card/mem_info_vram_used")
total=$(<"$card/mem_info_vram_total")

awk -v u="$used" -v t="$total" 'BEGIN { printf "%.0f%%\n", (u / t) * 100 }'
