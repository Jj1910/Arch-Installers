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

## Grub Configuration
#pacman -Sy grub efibootmgr dosfstools mtools

#sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/g' /etc/default/grub
#sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt loglevel=4 nvidia_drm.modeset=1"/g' /etc/default/grub
#sed -i 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/g' /etc/default/grub

## Only used for NVIDIA GPU
sed -i 's/MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf

## Only used for NVIDIA GPU and RAID
#sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf keyboard keymap consolefont block mdadm_udev filesystems fsck)/g' /etc/mkinitcpio.conf

## Only used for NVIDIA GPU and no RAID
sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf keyboard keymap consolefont block filesystems fsck)/g' /etc/mkinitcpio.conf

## Only used if creating a RAID Array

#sed -i 's/BINARIES=.*/BINARIES=(/sbin/mdmon)/g' /etc/mkinitcpio.conf

## Only used if not using a UKI to boot

#sed -i 's/#COMPRESSION="lz4"/COMPRESSION="lz4"/g' /etc/mkinitcpio.conf

mkinitcpio -p linux

## Grub Install
#grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck

#echo "menuentry 'Windows 11' {
#	search --fs-uuid --set=root BA2C-C152
#	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
#}" >> /etc/grub.d/40_custom

#grub-mkconfig -o /boot/grub/grub.cfg

## Systemd Install
#bootctl install

#echo "default arch.conf
#timeout 0
#console-mode auto" > /boot/loader/loader.conf

blkid

echo "Enter Root Partition UUID (PARTUUID)"

read $partuuid

#echo "title Arch Linux
#linux /vmlinuz-linux
#initrd /initramfs-linux.img
#options root=PARTUUID=$partuuid rw" > /boot/loader/entries/arch.conf

#echo "title Arch Linux Fallback
#linux /vmlinuz-linux
#initrd /initramfs-linux-fallback.img
#options root=PARTUUID=$partuuid rw" > /boot/loader/entries/arch-fallback.conf

## UKI Booting

echo '# mkinitcpio preset file for the 'linux' package

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/boot/EFI/Linux/arch-linux.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="/boot/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"' > /etc/mkinitcpio.d/linux.preset

echo "root=PARTUUID=$partuuid rw intel_iommu=on iommu=pt" > /etc/kernel/cmdline

pacman -S sbctl efibootmgr

sbctl create-keys

sbctl enroll-keys --microsoft

mkinitcpio -P

lsblk

echo "Enter Boot Device"

read $boot

echo "Enter Boot Partition Number (Usually 1)"

read $part

efibootmgr --create --disk /dev/$boot --part $part --label "Arch Linux" --loader '\EFI\Linux\arch-linux.efi' --unicode

efibootmgr --create --disk /dev/$boot --part $part --label "Arch Linux Fallback" --loader '\EFI\Linux\arch-linux-fallback.efi' --unicode

# Networking without NetworkManager

ip a

echo "Enter Device Name"

read $Device

echo "Enter IP with Subnet"

read $IP

echo "Enter Gateway IP"

read $Gateway

echo "Enter DNS Server"

read $DNS

echo "[Match]
Name=$Device

[Network]
Address=$IP
Gateway=$Gateway
DNS=$DNS" > /etc/systemd/network/network.network

echo "# NAS-Storage
//nas/nas /NAS cifs _netdev,x-systemd.automount,x-systemd.mount-timeout=1,credentials=,uid=1000,gid=1000 0 0" >> /etc/fstab

systemctl enable systemd-timesyncd systemd-networkd systemd-resolved
systemctl disable systemd-networkd-wait-online

exit
