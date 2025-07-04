# setup.sh

# Redirect all output to a file
LOG_FILE="/root/setup.log"

source /root/utils.sh

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

activate_log

# Allow wheel group to use sudo
log "Allowing wheel group to use sudo"
sed -i 's/^# \(%wheel ALL=(ALL:ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

### Enable NetworkManager
log "Enabling NetworkManager"
systemctl enable --now NetworkManager
pacman -S --noconfirm networkmanager-openvpn

# Wait for the network to be up
log "Waiting for network..."
while ! ping -c 1 archlinux.org &> /dev/null; do
    echo "Waiting for network..."
    sleep 1
done

setup_extra "reflector"
setup_extra "pacman"

setup_extra "yay"
setup_extra "zsh"
setup_extra "rofi" # required by i3
setup_extra "alacritty" # required by i3
setup_extra "i3"
setup_extra "xorg"
setup_extra "redshift"
setup_extra "dunst"
setup_extra "github"

# Essential utilities
log "Installing essential utilities"
pacman -S --noconfirm eza plocate less xclip

# Development tools
log "Installing development tools"
pacman -S --noconfirm git npm pnpm dbeaver
setup_extra "python"
setup_extra "rust"
setup_extra "mariadb"
setup_extra "docker"
setup_extra "mongodb"

# Audio
log "Installing audio tools"
pacman -S --noconfirm pipewire pipewire-pulse pavucontrol

# VirtualBox Guest Additions - TODO: Make optional
# log "Installing VirtualBox Guest Additions"
# pacman -S --noconfirm virtualbox-guest-utils
# systemctl enable --now vboxservice

setup_extra "vscode"
setup_extra "thunderbird"

# Apps/Media
log "Installing apps and media"
pacman -S --noconfirm vivaldi vivaldi-ffmpeg-codecs firefox vlc spotify-launcher obsidian noto-fonts-emoji noto-fonts-cjk flameshot discord
yay -S --noconfirm emote

# Set /home/$username permissions
log "Setting /home/$username permissions"
chown -R $username:$username /home/$username

log "Setup complete. Rebooting in 5 seconds..."
sleep 5
reboot
