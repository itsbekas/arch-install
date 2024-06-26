yay -S --noconfirm visual-studio-code-bin
pacman -S --noconfirm ttf-fira-code
download_config "vscode/settings.json" "/home/$username/.config/Code/User/settings.json"
download_config "vscode/keybindings.json" "/home/$username/.config/Code/User/keybindings.json"