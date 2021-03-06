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

mkfs.ext4 "/dev/$rootpartitionname"
mkswap "/dev/$swappartitionname"
mkfs.fat -F 32 "/dev/$bootpartitionname"

mount "/dev/$rootpartitionname" /mnt
swapon "/dev/$swappartitionname"
mkdir -p /mnt/boot/efi
mount "/dev/$bootpartitionname" /mnt/boot/efi

pacstrap /mnt base linux base-devel pulseaudio linux-headers linux-firmware nano grub efibootmgr wget
 
genfstab -U /mnt >> /mnt/etc/fstab

cp chroot.sh /mnt/chroot.sh

arch-chroot /mnt ./chroot.sh
