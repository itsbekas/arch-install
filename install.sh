# install.sh - A script to install Arch Linux
# This script is meant to be run after booting into the Arch Linux live environment
# It will install Arch Linux on the system


# TODO: Take repo as argument for a config file

# Set the keyboard map
loadkeys pt-latin1

# TODO: Check that the time is correct
# timedatectl # Filter the output to get the time

# Partition the disk
# TODO: Accept config file for sfdisk
# TODO: Get the disk from config file or fdisk -l
# TODO: Print instructions to create the partitions when there's no config file
curl -s https://raw.githubusercontent.com/itsbekas/arch-install/master/sfdisk-cfg | sfdisk /dev/sda

# Format the partitions
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount the partitions
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Update the mirrorlist
reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
# Allow parallel downloads
sed -i 's/^#\(ParallelDownloads = 5\)/\1/' /etc/pacman.conf

# Install essential packages
# TODO: Accept config file for packages
# Always deal with pgp key is unknown trust, just in case
pacman -Sy --noconfirm archlinux-keyring
pacstrap /mnt base base-devel linux linux-firmware vim networkmanager amd-ucode grub efibootmgr

# Configure the system
genfstab -U /mnt >> /mnt/etc/fstab
chr='arch-chroot /mnt'

## START OF CHROOT ##
# Set the timezone
${chr} ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
# Set the hardware clock
${chr} hwclock --systohc
# Set the locale
${chr} sed -i 's/^#\(\(en_US\|pt_PT\)\.UTF-8\)/\1/' /etc/locale.gen
# Generate the locale
${chr} locale-gen
# Set the language
${chr} tee /etc/locale.conf <<< "LANG=en_US.UTF-8"
# Set the keyboard layout
${chr} tee /etc/vconsole.conf <<< "KEYMAP=pt-latin1"
# Set the hostname
${chr} tee /etc/hostname <<< "bernardo-arch"
# Set the root password
echo "You will be prompted to set the root password"
valid_password=false
while [ $valid_password = false ]; do
    read -sp "Enter the root password: " root_password
    echo
    read -sp "Confirm the root password: " root_password_confirm
    echo
    if [ $root_password = $root_password_confirm ]; then
        valid_password=true
    else
        echo "The passwords do not match. Please try again."
    fi
done

${chr} chpasswd <<< root:$root_password
echo "Root password set successfully"

# Install and configure the bootloader
${chr} grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
${chr} grub-mkconfig -o /boot/grub/grub.cfg
# TODO: Add dual boot support

# Download setup script
${chr} curl -s https://raw.githubusercontent.com/itsbekas/arch-install/master/setup.sh -o /root/setup.sh
## END OF CHROOT ##

# Unmount the partitions
umount -R /mnt

echo "Installation complete. You can now reboot the system."
