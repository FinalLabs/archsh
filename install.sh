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

pacstrap /mnt base linux base-devel pulseaudio linux-headers linux-firmware nano grub efibootmgr wget
 
genfstab -U /mnt >> /mnt/etc/fstab

wget -O /root/chroot.sh https://raw.githubusercontent.com/FinalLabs/arch-install-script/main/chroot.sh

arch-chroot /mnt /root/chroot.sh
