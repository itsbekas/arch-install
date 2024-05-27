pacman -S --noconfirm --needed git base-devel 
su $username -c "git clone https://aur.archlinux.org/yay-bin.git /home/$username/yay-bin && cd /home/$username/yay-bin && makepkg -si --noconfirm && cd .. && rm -rf yay-bin"
