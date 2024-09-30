username=$(whoami)

if [ "$username" = "root" ]; then
    echo "This script should not be run as root"
    exit 1
fi

# Link this repository's files to their location
update_config() {
    local repo_path=$1
    local device_path=$2
    echo "Linking $device_path to config/$repo_path"
    mkdir -p "$(dirname "$device_path")"
    ln -sf "$(pwd)/config/$repo_path" "$device_path"
    chown $username:$username "$device_path"
}

sudo_update_config() {
    local repo_path=$1
    local device_path=$2
    echo "Linking $device_path to config/$repo_path"
    sudo mkdir -p "$(dirname "$device_path")"
    sudo ln -sf "$(pwd)/config/$repo_path" "$device_path"
    sudo chown root:root "$device_path"
}

# Download the config files
update_config "i3/config" "/home/$username/.config/i3/config"
sudo_update_config "reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"
update_config "vscode/settings.json" "/home/$username/.config/Code/User/settings.json"
update_config "vscode/keybindings.json" "/home/$username/.config/Code/User/keybindings.json"
update_config "xorg/.xinitrc" "/home/$username/.xinitrc"
update_config "zsh/.zshrc" "/home/$username/.zshrc"
update_config "zsh/.p10k.zsh" "/home/$username/.p10k.zsh"
update_config "zsh/.zprofile" "/home/$username/.zprofile"
update_config "redshift/redshift.conf" "/home/$username/.config/redshift/redshift.conf"
update_config "dunst/dunstrc" "/home/$username/.config/dunst/dunstrc"