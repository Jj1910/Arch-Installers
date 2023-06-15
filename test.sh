#!/bin/bash

setfont ter-132n

timedatectl set-timezone America/New_York

lsblk

echo "Enter block device"

read blockdevice

cfdisk /dev/$blockdevice

lsblk

echo "Enter swap partition"

read swappartition

echo "Enter root partition"

read rootpartition

echo "Enter home partition"

read homepartition

mkfs.ext4 /dev/$rootpartition

mkfs.ext4 /dev/$homepartition

mkswap /dev/$swappartition

swapon /dev/$swappartition

mount /dev/$rootpartition /mnt

mkdir /mnt/home

mount /dev/$homepartition /mnt/home

lsblk

echo "Enter packages you want installed (Default base base-devel linux linux-firmware linux-headers intel-ucode sudo nano dhcpcd gvim)

read packages

pacstrap -K /mnt $packages base base-devel linux linux-firmware linux-headers intel-ucode sudo nano dhcpcd gvim

genfstab -U /mnt > /mnt/etc/fstab

arch-chroot /mnt

echo "Enter root password"

passwd

echo "Enter username"

read user

useradd -m $user

echo "Enter user password"

passwd $user

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

export LANG=en_US.UTF-8

echo "Enter Hostname"

read hostname

echo $hostname > /etc/hostname

echo "127.0.0.1      localhost
::1            localhost
127.0.1.1      $hostname.localdomain  localhost" >> /etc/hosts

cat /etc/hosts

echo "wait"

read $null

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc

pacman -S grub efibootmgr dosfstools mtools

mkinitcpio -p linux

echo "Now go install grub"
