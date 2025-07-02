#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <wallpaper_id|wallpaper_url>"
  exit 1
fi

# check if it's an existing file
if [ -f "$1" ]; then
    feh --bg-fill "$1" || {
        echo "Failed to set wallpaper from file $1."
        exit 1
    }
    echo "Wallpaper set to $1."
    exit 0
fi

# check if it's in format of a wallhaven wallpaper ID (https://wallhaven.cc/w/abc123) or just the ID (xyz456)
if [[ "$1" =~ ^(https?://wallhaven.cc/w/)?([a-zA-Z0-9]{6})$ ]]; then
  wp_id="${BASH_REMATCH[2]}"
elif [[ "$1" =~ ^[a-zA-Z0-9]{6}$ ]]; then
  wp_id="$1"
else
  echo "Invalid wallpaper ID or URL format."
  exit 1
fi

wp_dir="$HOME/.wallpapers"
ext="jpg"

if [ ! -f "$wp_dir/wallhaven-$wp_id.jpg" ] && [ ! -f "$wp_dir/wallhaven-$wp_id.png" ]; then
  echo "Downloading wallpaper with ID $wp_id..."
  mkdir -p "$wp_dir"
  wget -q "https://w.wallhaven.cc/full/${wp_id:0:2}/wallhaven-$wp_id.jpg" -O "$wp_dir/wallhaven-$wp_id.jpg"
  if [ $? -eq 8 ]; then
    rm "$wp_dir/wallhaven-$wp_id.jpg"
    wget -q "https://w.wallhaven.cc/full/${wp_id:0:2}/wallhaven-$wp_id.png" -O "$wp_dir/wallhaven-$wp_id.png"
    ext="png"
    if [ $? -ne 0 ]; then
      echo "Failed to download wallpaper with ID $wp_id."
      exit 1
    fi
  fi
fi

echo $ext

feh --bg-fill "$wp_dir/wallhaven-$wp_id.$ext" || {
  echo "Failed to set wallpaper with ID $wp_id."
  exit 1
}
echo "Wallpaper set to wallhaven-$wp_id.$ext."
