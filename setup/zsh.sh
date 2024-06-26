pacman -S --noconfirm sudo zsh
bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended
download_config "zsh/.zshrc" "/home/$username/.zshrc"
download_config "zsh/.p10k.zsh" "/home/$username/.p10k.zsh"
yay -S --noconfirm zsh-theme-powerlevel10k-git
chsh -s /bin/zsh $username