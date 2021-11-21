#/bin/bash
lsblk

$userdiskname

read -p "Enter disk name (/dev/sdX): " userdiskname

cfdisk $userdiskname

clear

$rootpartitionname
$swappartitionname
$bootpartitionname
lsblk
read -p "Enter number for root partition (ex. 1): " $rootpartitionname
read -p "Enter name for swap partition (ex. 2): " $swappartitionname
read -p "Enter name for boot partition (ex. 3): " $bootpartitionname
clear

echo $rootpartitionname
echo $swappartitionname
echo $bootpartitionname

read -p "" enter

mkfs.ext4 $rootpartitionname
mkswap $swappartitionname
mkfs.fat -F 32 $bootpartitionname

read -p "" enter

mount $rootpartitionname /mnt
swapon $swappartitionname
mkdir /mnt/boot/efi
mount $bootpartitionname /mnt/boot/efi

read -p "" enter

pacstrap /mnt base linux base-devel pulseaudio linux-headers linux-firmware nano os-prober grub efibootmgr

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

$timename
read -p "Enter name for time (Region/City - ex. America/New_York): " $timename
ln -sf /usr/share/zoneinfo/$timename /etc/localtime

hwclock --systohc

nano /etc/locale.gen
locale-gen

$localename
read -p "Enter name for locale: " $localename

touch /etc/locale.conf
echo "LANG=$localename" > /etc/locale.conf
cat /etc/locale.conf

$hostname
read -p "Enter hostname:" $hostname
echo $hostname > /etc/hostname

echo "Set password for root!"
passwd

os-prober
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
reboot
