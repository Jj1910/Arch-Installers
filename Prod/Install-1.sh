#!/bin/bash

setfont ter-132n

timedatectl set-timezone America/New_York

lsblk

echo "Enter Disk (Don't include /dev/)"

read disk

cfdisk /dev/$disk

lsblk

echo "Enter Swap Partition"

read swappart

echo "Enter Root Partition"

read rootpart

echo "Enter Home Partition"

read homepart

mount /dev/$rootpart /mnt

mkdir /mnt/home

mount /dev/$homepart /mnt/home

lsblk

echo "Enter Extra Packages to Install (Default: base base-devel linux linux-firmware linux-headers intel-ucode sudo nano dhcpcd mdadm ntfs03g nvidia gvim git)"

read packages

pacstrap -K -i /mnt $packages base base-devel linux linux-firmware linux-headers intel-ucode sudo nano dhcpcd mdadm ntfs03g nvidia gvim git

genfstab -U /mnt > /mnt/etc/fstab

lsblk

echo "Enter EFI Partition"

read efipart

mkdir /mnt/efi

mount /dev/$efipart /mnt/efi

mdadm --detail --scan >> /mnt/etc/mdadm.conf

echo "Make sure to correct genfstab if RAID is configured"

sleep 1

arch-chroot /mnt