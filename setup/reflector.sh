pacman -S --noconfirm reflector
curl $BASE_REPO/config/reflector/reflector.conf -o /etc/xdg/reflector/reflector.conf
bash <(curl -s $BASE_REPO/config/reflector/config.sh) /etc/xdg/reflector/reflector.conf
systemctl start reflector
systemctl enable --now reflector.timer