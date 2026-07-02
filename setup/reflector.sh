pacman -S --noconfirm reflector
download_config "reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"
systemctl start reflector
systemctl enable --now reflector.timer