# setup.sh

# Function to download config file
download_config() {
    local repo_path=$1
    local device_path=$2
    mkdir -p "$(dirname "$device_path")"
    curl "$BASE_REPO/$repo_path" -o "$device_path"
    chown $username:$username "$device_path"
}

BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/master"

### Enable NetworkManager
systemctl enable --now NetworkManager

### Setup reflector
pacman -S --noconfirm reflector
curl $BASE_REPO/config/reflector/reflector.conf -o /etc/xdg/reflector/reflector.conf
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

useradd -m -G wheel $username
echo "$username:$password" | chpasswd

# Allow wheel group to use sudo
sed -i 's/^# \(%wheel ALL=(ALL:ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

### Setup YAY - makepkg can't be run as root
pacman -S --noconfirm --needed git base-devel 
su $username -c "git clone https://aur.archlinux.org/yay-bin.git /home/$username/yay-bin && cd /home/$username/yay-bin && makepkg -sci --noconfirm"

### Setup zsh
pacman -S --noconfirm sudo zsh
bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended
download_config "config/zsh/.zshrc" "/home/$username/.zshrc"
download_config "config/zsh/.p10k.zsh" "/home/$username/.p10k.zsh"
yay -S --noconfirm zsh-theme-powerlevel10k-git
chsh -s /bin/zsh $username

### Setup i3
base_i3_pkgs="xorg-server xorg-xinit i3-wm noto-fonts"

pacman -Syyu --noconfirm ${base_i3_pkgs}

download_config "config/i3/config" "/home/$username/.config/i3/config"

pacman --noconfirm -S xf86-video-amdgpu
download_config "config/xorg-xinit/.xinitrc" "/home/$username/.xinitrc"


util_packages="alacritty rofi eza"

pacman -S --noconfirm ${util_packages}
