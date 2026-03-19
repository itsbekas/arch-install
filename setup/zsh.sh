pacman -S --noconfirm sudo zsh starship
bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended
download_config "zsh/.zshrc" "/home/$username/.zshrc"
download_config "zsh/.aliases.zshrc" "/home/$username/.aliases.zshrc"
download_config "zsh/.zprofile" "/home/$username/.zprofile"
download_config "starship/starship.toml" "/home/$username/.config/starship/starship.toml"
chsh -s /bin/zsh $username