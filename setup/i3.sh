pacman -S --noconfirm xorg-server xorg-xinit xf86-video-amdgpu i3-wm noto-fonts i3status i3lock
download_config "config/i3/config" "/home/$username/.config/i3/config"
download_config "config/xorg-xinit/.xinitrc" "/home/$username/.xinitrc"