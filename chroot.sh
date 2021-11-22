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
cat /etc/hostname

echo "Set password for root!"
passwd

grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
reboot