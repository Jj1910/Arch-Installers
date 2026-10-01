#!/usr/bin/env bash

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

## Only used for NVIDIA GPU
sed -i 's/MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf

## Only used for NVIDIA GPU and no RAID
sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf keyboard keymap consolefont block filesystems fsck)/g' /etc/mkinitcpio.conf

mkinitcpio -p linux

blkid

echo "Enter Root Partition UUID (PARTUUID)"

read $partuuid

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

#Optional Bridge for VMs
echo '[NetDev]
Name=bond0
Kind=bond

[Bond]
Mode=active-backup
PrimaryReselectPolicy=always
MIIMonitorSec=1s
MACAddress=b6:77:d3:76:d4:00' > /etc/systemd/network/05-bond0.netdev

echo '[Match]
Name=enp7s0

[Network]
Bond=bond0
PrimarySlave=true' > /etc/systemd/network/05-ethernet-bond0.network

echo '[Match]
Name=wlo1

[Network]
Bond=bond0' > /etc/systemd/network/05-wifi-bond0.network

echo '[Match]
Name=bond0

[Network]
Bridge=br0' > /etc/systemd/network/10-br0-bond.network

echo '[NetDev]
Name=br0
Kind=bridge
MACAddress=b6:77:d3:76:d4:00' > /etc/systemd/network/10-br0.netdev

echo 'Description=Bridge with Bonded Interfaces
IPv6AcceptRA=no
LinkLocalAddressing=no
DHCP=ipv4' > /etc/systemd/network/10-br0.network

echo "# NAS-Storage
//nas/nas /NAS cifs _netdev,x-systemd.automount,x-systemd.mount-timeout=1,credentials=,uid=1000,gid=1000 0 0" >> /etc/fstab

systemctl enable systemd-timesyncd systemd-networkd systemd-resolved

sudo rm -rf /etc/resolv.conf 
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

exit
