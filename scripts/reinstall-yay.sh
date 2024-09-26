sudo pacman -R --noconfirm yay
sudo pacman -R --noconfirm yay-bin
sudo pacman -S --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay
echo "yay has been reinstalled."