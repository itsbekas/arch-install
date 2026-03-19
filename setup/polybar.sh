pacman -S --noconfirm polybar ttf-jetbrains-mono-nerd
download_config "polybar/config.ini" "/home/$username/.config/polybar/config.ini"
download_config "polybar/launch.sh" "/home/$username/.config/polybar/launch.sh"
chmod +x "/home/$username/.config/polybar/launch.sh"
download_config "polybar/spotify.sh" "/home/$username/.config/polybar/spotify.sh"
chmod +x "/home/$username/.config/polybar/spotify.sh"
