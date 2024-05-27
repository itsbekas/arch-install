sed -i 's/^#\(ParallelDownloads =\) 5/\1 10/' /etc/pacman.conf
pacman -S --noconfirm archlinux-keyring