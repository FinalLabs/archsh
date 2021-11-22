#/bin/bash
clear

$timename
read -p "Enter name for time (Region/City - ex. America/New_York): " timename
ln -sf "/usr/share/zoneinfo/$timename" /etc/localtime

hwclock --systohc

nano /etc/locale.gen
locale-gen

$localename
read -p "Enter name for locale: " localename

echo "LANG=$localename" > /etc/locale.conf
cat /etc/locale.conf

$hostname
read -p "Enter hostname:" hostname
echo "$hostname" > /etc/hostname

echo "Set password for root!"
passwd

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
reboot
