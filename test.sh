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
