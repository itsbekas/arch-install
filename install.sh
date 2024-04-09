# TODO: Take repo as argument for a config file

# Set the keyboard map
loadkeys pt-latin1

# TODO: Check that the time is correct
# timedatectl # Filter the output to get the time

# Partition the disk
# TODO: Accept config file for sfdisk
# TODO: Get the disk from config file or fdisk -l
# TODO: Print instructions to create the partitions when there's no config file
curl -s https://raw.githubusercontent.com/itsbekas/arch-install/auto-fdisk/sfdisk-cfg | sfdisk /dev/sda

# Format the partitions
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount the partitions
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Update the mirrorlist
systemctl start reflector.service

# Install essential packages
# TODO: Accept config file for packages
# TODO: Deal with pgp keys being wrong (install archlinux-keyring)
pacstrap /mnt base base-devel linux linux-firmware vim networkmanager amd-ucode grub efibootmgr

# Configure the system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

## START OF CHROOT ##
# Set the timezone
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
# Set the hardware clock
hwclock --systohc
# Set the locale
sed -i 's/^#\(\(en_US\|pt_PT\)\.UTF-8\)/\1/' /etc/locale.gen
# Generate the locale
locale-gen
# Set the language
echo "LANG=en_US.UTF-8" > /etc/locale.conf
# Set the keyboard layout
echo "KEYMAP=pt-latin1" > /etc/vconsole.conf
# Set the hostname
echo "bernardo-arch" > /etc/hostname
# Set the root password
echo "You will be prompted to set the root password"
passwd

# Install and configure the bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# TODO: Add dual boot support

## END OF CHROOT ##
echo "Installation complete. You can now reboot the system."
exit
