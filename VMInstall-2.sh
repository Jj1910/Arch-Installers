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

lsblk

echo "Enter Disk where Grub should be installed"

read disk

grub-install --target=i386-pc /dev/$disk

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd systemd-timesyncd

exit
