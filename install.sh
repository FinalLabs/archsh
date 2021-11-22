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
read -p "Enter number for root partition (ex. sdX1): " rootpartitionname
read -p "Enter name for swap partition (ex. sdX2): " swappartitionname
read -p "Enter name for boot partition (ex. sdX3): " bootpartitionname
clear

echo $rootpartitionname
echo $swappartitionname
echo $bootpartitionname

mkfs.ext4 "/dev/$rootpartitionname"
mkswap "/dev/$swappartitionname"
mkfs.fat -F 32 "/dev/$bootpartitionname"

mount "/dev/$rootpartitionname" /mnt
swapon "/dev/$swappartitionname"
mkdir -p /mnt/boot
mount "/dev/$bootpartitionname" /mnt/boot

pacstrap /mnt base linux base-devel pulseaudio linux-headers linux-firmware nano grub efibootmgr

clear
read -p "press enter" enter

genfstab -U /mnt >> /mnt/etc/fstab

clear
read -p "press enter" enter

touch /root/arch-install.sh

$archchrootdir /root/arch-install.sh

$scriptchroot "\$timename
read -p 'Enter name for time (Region/City - ex. America/New_York):' timename
ln -sf '/usr/share/zoneinfo/\$timename' /etc/localtime

hwclock --systohc

nano /etc/locale.gen
locale-gen

\$localename
read -p 'Enter name for locale: ' localename

echo 'LANG=\$localename' > /etc/locale.conf
cat /etc/locale.conf

\$hostname
read -p 'Enter hostname:' hostname
cat /etc/hostname

echo 'Set password for root!'
passwd

grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
reboot"

echo scriptchroot >> archchrootdir
arch-chroot /mnt /root/chroot-install.sh
