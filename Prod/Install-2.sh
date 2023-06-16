#!/bin/bash

echo "Enter Root Password"

passwd

echo "Enter Username"

read user

useradd -m $user

echo "Enter $user's password"

passwd $user

echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

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

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc

pacman -Sy grub efibootmgr dosfstools mtools

sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt loglevel=4 nvidia_drm.modeset=1"/g' /etc/default/grub
sed -i 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/g' /etc/default/grub

sed -i 's/MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf
sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf keyboard keymap consolefont block filesystems fsck)/g' /etc/mkinitcpio.conf

mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck

grub-mkconfig -o /boot/grub/grub.cfg

echo "menuentry 'Windows 10' {
	search --fs-uuid --set=root 68F8-8219
	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}" >> /boot/grub.d/40_custom

systemctl enable dhcpcd systemd-timesyncd

exit
