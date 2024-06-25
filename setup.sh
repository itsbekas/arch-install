# setup.sh

### Enable NetworkManager
systemctl enable --now NetworkManager

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

# Wait for the network to be up
while ! ping -c 1 archlinux.org &> /dev/null; do
    echo "Waiting for network..."
    sleep 1
done

# Load utils
source <(curl -fsSL https://raw.githubusercontent.com/itsbekas/arch-install/master/utils.sh)

setup_extra "reflector"
setup_extra "pacman"


setup_extra "yay"
setup_extra "zsh"
setup_extra "rofi" # required by i3
setup_extra "alacritty" # required by i3
setup_extra "i3"

# Essential utilities
pacman -S --noconfirm eza plocate

# VirtualBox Guest Additions
pacman -S --noconfirm virtualbox-guest-utils
systemctl enable --now vboxservice

# VS Code
yay -S --noconfirm visual-studio-code-bin

# Apps/Media
pacman -S --noconfirm vivaldi vivaldi-ffmpeg-codecs firefox vlc spotify-launcher

# Set /home/$username permissions
chown -R $username:$username /home/$username

#reboot
