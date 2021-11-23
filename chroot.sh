#/bin/bash
clear

pacman -S zsh grub git reflector pulseaudio 

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
read -p "Enter hostname: " hostname
echo $hostname > /etc/hostname

echo "127.0.0.1 localhost" > /etc/hosts
echo "::1 localhost" > /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" > /etc/hosts

echo "Set password for root!"
passwd

$username
read -p "Enter username: " username
useradd -s /usr/bin/zsh -G wheel $username
passwd $username

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
