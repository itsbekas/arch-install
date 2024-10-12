# Download utils
curl -fsSL https://raw.githubusercontent.com/itsbekas/arch-install/${branch}/utils.sh -o /tmp/arch-install/utils.sh
source /tmp/arch-install/utils.sh

# Download the config files
download_config "i3/config" "/home/$username/.config/i3/config"
download_config "reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"
download_config "vscode/settings.json" "/home/$username/.config/Code/User/settings.json"
download_config "vscode/keybindings.json" "/home/$username/.config/Code/User/keybindings.json"
download_config "xorg/.xinitrc" "/home/$username/.xinitrc"
download_config "zsh/.zshrc" "/home/$username/.zshrc"
download_config "zsh/.p10k.zsh" "/home/$username/.p10k.zsh"
download_config "zsh/.zprofile" "/home/$username/.zprofile"
download_config "redshift/redshift.conf" "/home/$username/.config/redshift/redshift.conf"
download_config "dunst/dunstrc" "/home/$username/.config/dunst/dunstrc"