# setup.sh

BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/master"

### Enable NetworkManager
systemctl enable --now NetworkManager

### Setup reflector
pacman -S --noconfirm reflector
curl -s $BASE_REPO/config/reflector/reflector.conf > /etc/xdg/reflector/reflector.conf
bash <(curl -s $BASE_REPO/config/reflector/config.sh) /etc/xdg/reflector/reflector.conf
systemctl enable --now reflector.timer

### Setup pacman
sed -i 's/^#\(ParallelDownloads =\) 5/\1 10/' /etc/pacman.conf
pacman -S --noconfirm archlinux-keyring

### Setup user
pacman -S --noconfirm sudo zsh
read -p "Enter the username: " username
valid_password=false
while [ $valid_password = false ]; do
    read -sp "Enter the password: " password
    echo
    read -sp "Confirm the password: " password_confirm
    echo
    if [ $password = $password_confirm ]; then
        valid_password=true
    else
        echo "The passwords do not match. Please try again."
    fi
done

useradd -m -G wheel -s /bin/zsh $username
echo "$username:$password" | chpasswd

# Allow wheel group to use sudo
sed -i 's/^# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers

### Setup zsh


### Setup i3
base_i3_pkgs="xorg-server xorg-xinit i3-wm noto-fonts"
extra_i3_pkgs="alacritty rofi"

pacman -Syyu --noconfirm ${base_i3_pkgs} ${extra_i3_pkgs}

curl -s $BASE_REPO/config/i3/config > ~$username/.config/i3/config
curl -s $BASE_REPO/config/xorg-xinit/.xinitrc > ~$username/.xinitrc
