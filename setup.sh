# setup.sh

BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/master"

### Enable NetworkManager
systemctl enable --now NetworkManager

### Setup reflector
pacman -S --noconfirm reflector
curl -s $BASE_REPO/config/reflector/reflector.conf | tee /etc/xdg/reflector/reflector.conf
bash <(curl -s $BASE_REPO/config/reflector/config.sh) /etc/xdg/reflector/reflector.conf
systemctl start reflector
systemctl enable --now reflector.timer

### Setup pacman
sed -i 's/^#\(ParallelDownloads =\) 5/\1 10/' /etc/pacman.conf
pacman -S --noconfirm archlinux-keyring

### Setup user
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

### Setup YAY - makepkg can't be run as root
su $username
pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
exit

useradd -m -G wheel $username
echo "$username:$password" | chpasswd

# Allow wheel group to use sudo
sed -i 's/^# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers

### Setup zsh
pacman -S --noconfirm sudo zsh
bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended
curl -s $BASE_REPO/config/zsh/.zshrc | tee ~$username/.zshrc
curl -s $BASE_REPO/config/zsh/.p10k.zsh | tee ~$username/.p10k.zsh
yay -S --noconfirm zsh-theme-powerlevel10k-git
chsh -s /bin/zsh $username

### Setup i3
base_i3_pkgs="xorg-server xorg-xinit i3-wm noto-fonts"
extra_i3_pkgs="alacritty rofi"

pacman -Syyu --noconfirm ${base_i3_pkgs} ${extra_i3_pkgs}

curl -s $BASE_REPO/config/i3/config | tee ~$username/.config/i3/config
curl -s $BASE_REPO/config/xorg-xinit/.xinitrc | tee ~$username/.xinitrc
