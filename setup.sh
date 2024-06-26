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
sed -i 's/^# \(%wheel ALL=(ALL:ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

### Enable NetworkManager
systemctl enable --now NetworkManager

# Wait for the network to be up
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

# Essential utilities
log "Installing essential utilities"
pacman -S --noconfirm eza plocate

# VirtualBox Guest Additions
log "Installing VirtualBox Guest Additions"
pacman -S --noconfirm virtualbox-guest-utils
systemctl enable --now vboxservice

setup_extra "vscode"

# Apps/Media
log "Installing apps and media"
pacman -S --noconfirm vivaldi vivaldi-ffmpeg-codecs firefox vlc spotify-launcher

# Set /home/$username permissions
log "Setting /home/$username permissions"
chown -R $username:$username /home/$username

log "Setup complete. Rebooting in 5 seconds..."
sleep 5
reboot
