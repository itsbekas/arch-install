#!/bin/bash

# Check sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

echo "In order to setup GRUB for dual-booting with an existing Windows installation, you need to provide the path to the EFI partition."
echo "You can find the EFI partition by running 'lsblk' and looking for a partition with the 'esp' flag."
read -p "Enter the path to the Windows EFI partition: " windows_efi_partition
read -p "Enter the path to the GRUB EFI partition: " efi_partition

echo "Mounting the EFI partitions..."
mkdir -p /mnt/windows_efi
mkdir -p /mnt/grub_efi
mount $windows_efi_partition /mnt/windows_efi
mount $efi_partition /mnt/grub_efi

pacman -S --noconfirm os-prober
# Activate OS Prober
sed -i 's/^#\(GRUB_DISABLE_OS_PROBER=false\)/\1/' /etc/default/grub
os-prober
grub-mkconfig -o /mnt/grub_efi/grub/grub.cfg

echo "Finished. Cleaning up..."
umount /mnt/windows_efi
umount /mnt/grub_efi
rmdir /mnt/windows_efi
rmdir /mnt/grub_efi
pacman -Rns --noconfirm os-prober

echo "Done."
