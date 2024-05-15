# setup.sh 

# Enable NetworkManager
systemctl enable --now NetworkManager

pacman -Syyu xorg-server xorg-xinit i3-wm noto-fonts zsh

read -sp "Enter the username: " username
read -sp "Enter the password: " password
echo

useradd -m -G wheel -s /bin/zsh $username
echo "$username:$password" | chpasswd

curl -s https://raw.githubusercontent.com/itsbekas/arch-install/master/config/.xinitrc > ~$username/.xinitrc
#curl -s https://raw.githubusercontent.com/itsbekas/arch-install/master/config/.zshrc > ~$username/.zshrc
