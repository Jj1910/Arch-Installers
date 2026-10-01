#!/usr/bin/env bash

setfont ter-132n

timedatectl set-timezone America/New_York

lsblk

echo "Enter Disk (Don't include /dev/)"

read disk

fdisk /dev/$disk

lsblk

echo "Enter Swap Partition"

read swappart

echo "Enter Root Partition"

read rootpart

echo "Enter Home Partition"

read homepart

echo "Enter EFI Partition"

read efipart

mkfs.ext4 /dev/$rootpart

mkfs.ext4 /dev/$homepart

mkswap /dev/$swappart

swapon /dev/$swappart

mount /dev/$rootpart /mnt

mkdir /mnt/home

mount /dev/$homepart /mnt/home

mkdir /mnt/boot

mount /dev/$efipart /mnt/boot

lsblk

echo "Enter Extra Packages to Install (Default: base base-devel linux linux-firmware linux-headers intel-ucode sudo nano nvidia git vim openssh cifs-utils timeshift)"

read packages

pacstrap -K -i /mnt $packages base base-devel linux linux-firmware linux-headers intel-ucode sudo nano nvidia git vim openssh cifs-utils timeshift

genfstab -U -p /mnt >> /mnt/etc/fstab

sleep 1

arch-chroot /mnt
