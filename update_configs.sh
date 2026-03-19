#!/usr/bin/env bash

# So this script works when run standalone on desktop (e.g. sync from GitHub)
branch="${branch:-master}"
username="${username:-$(whoami)}"

# Download utils
mkdir -p /tmp/arch-install
curl -fsSL "https://raw.githubusercontent.com/itsbekas/arch-install/${branch}/utils.sh" -o /tmp/arch-install/utils.sh
source /tmp/arch-install/utils.sh

# Download the config files
download_config "i3/config" "/home/$username/.config/i3/config"
download_config "reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"
download_config "vscode/settings.json" "/home/$username/.config/Code/User/settings.json"
download_config "vscode/keybindings.json" "/home/$username/.config/Code/User/keybindings.json"
download_config "xorg/.xinitrc" "/home/$username/.xinitrc"
download_config "zsh/.zshrc" "/home/$username/.zshrc"
download_config "zsh/.aliases.zshrc" "/home/$username/.aliases.zshrc"
download_config "zsh/.p10k.zsh" "/home/$username/.p10k.zsh"
download_config "zsh/.zprofile" "/home/$username/.zprofile"
download_config "redshift/redshift.conf" "/home/$username/.config/redshift/redshift.conf"
download_config "dunst/dunstrc" "/home/$username/.config/dunst/dunstrc"
download_config "picom/picom.conf" "/home/$username/.config/picom/picom.conf"
download_config "polybar/config.ini" "/home/$username/.config/polybar/config.ini"
download_config "polybar/launch.sh" "/home/$username/.config/polybar/launch.sh"
download_config "polybar/spotify.sh" "/home/$username/.config/polybar/spotify.sh"
download_config "rofi/config.rasi" "/home/$username/.config/rofi/config.rasi"