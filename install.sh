# install.sh - A script to install Arch Linux
# This script is meant to be run after booting into the Arch Linux live environment
# It will install Arch Linux on the system

# TODO: retrieve possible configs (branches) from repo
read -p "Choose a configuration: " branch

# Redirect all output to a file
LOG_FILE="/install.log"
UTILS_FILE="/utils.sh"

# Download utils
curl -fsSL https://raw.githubusercontent.com/itsbekas/arch-install/${branch}/utils.sh -o $UTILS_FILE
source $UTILS_FILE

activate_log

# TODO: Take repo as argument for a config file

# TODO: Check that the time is correct
# timedatectl # Filter the output to get the time

# Partition the disk
# TODO: Accept config file for sfdisk
# TODO: Get the disk from config file or fdisk -l
# TODO: Print instructions to create the partitions when there's no config file
log "Partitioning the disk"
curl -s https://raw.githubusercontent.com/itsbekas/arch-install/${branch}/sfdisk-cfg | sfdisk /dev/sda

# Format the partitions
log "Formatting the partitions"
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount the partitions
log "Mounting the partitions"
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Update the mirrorlist
log "Setting up the mirrorlist"
reflector --latest 25 --threads $(nproc) -p https -c PT,ES,FR,GB,DE --sort rate --save /etc/pacman.d/mirrorlist

# Allow 10 parallel downloads
log "Allowing 10 parallel downloads"
sed -i 's/^#\(ParallelDownloads =\) 5/\1 10/' /etc/pacman.conf

# Install essential packages
# TODO: Accept config file for packages
# Always deal with pgp key is unknown trust, just in case
log "Installing essential packages"
pacman -Sy --noconfirm archlinux-keyring
pacstrap /mnt base base-devel linux linux-firmware vim networkmanager network-manager-applet amd-ucode grub efibootmgr

# Configure the system
log "Configuring the system"
genfstab -U /mnt >> /mnt/etc/fstab
chr='arch-chroot /mnt'

## START OF CHROOT ##
log "Setting up the time and locale"
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
log "Setting up the hostname"
read -p "Enter the hostname: " hostname
${chr} tee /etc/hostname <<< $hostname
# Set the root password
log "Setting up the root password"
deactivate_log
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

activate_log

${chr} chpasswd <<< root:$root_password

# Install and configure the bootloader
${chr} grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
${chr} grub-mkconfig -o /boot/grub/grub.cfg
# TODO: Add dual boot support

# Download setup script
${chr} curl https://raw.githubusercontent.com/itsbekas/arch-install/${branch}/setup.sh -o /root/setup.sh
${chr} chmod +x /root/setup.sh
## END OF CHROOT ##

# Copy the log to the new system
cp $LOG_FILE /mnt/root/install.log
# Copy the utils to the new system
cp $UTILS_FILE /mnt/root/utils.sh

# Unmount the partitions
umount -R /mnt

log "Installation complete. System will reboot in 5 seconds."
sleep 5
reboot
