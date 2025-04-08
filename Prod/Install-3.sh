#!/bin/bash

#git clone https://aur.archlinux.org/yay.git
#cd yay
#makepkg -si
#
#cd ~/
#
#yay -S picom-git
#
#mkdir ~/.config/picom
#
#sudo cp /etc/xdg/picom.conf.example ~/.config/picom/
#
#echo 'backend = "glx";
#glx-no-stencil = true;
#glx-copy-from-front = false;' >> ~/.config/picom/picom.conf
#
#sudo pacman -Sy nvidia-settings i3 xorg xorg-xinit nitrogen alacritty firefox thunar sddm ttf-firacode-nerd pipewire-jack pipewire-alsa pipewire-pulse qjackctl pavucontrol pass cifs-utils polybar rofi remmina freerdp python3 xclip htop qt5-quickcontrols2 qt5-graphicaleffects qt5-svg ncdu gvfs gnome-calculator pacman-contrib neofetch
#
#yay -S openrgb
#
#mkdir ~/.config/alacritty
#
#sudo cp /usr/share/doc/alacritty/example/alacritty.yml ~/.config/alacritty/alacritty.yml
#
#touch ~/.xinitrc
#
#echo "nitrogen --restore &
#picom &
#exec i3" > .xinitrc
#
#echo '[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -vt1' >> ~/.bash_profile
#
#sudo systemctl enable sddm
#
#sudo pacman -Rns dmenu
#
#sudo ln -s /usr/bin/rofi /usr/bin/dmenu
#
#cd ~/
#
#git clone https://github.com/rototrash/tokyo-night-sddm.git ~/tokyo-night-sddm
#
#sudo mv ~/tokyo-night-sddm /usr/share/sddm/themes/
#
#sudo sed -i 's/Current=.*/Current=tokyo-night-sddm/g' /etc/sddm.conf.d/default.conf
#
#
#
#echo "Should be ready to update dot files"

## Typical Packages
sudo pacman -S  pipewire-jack pipewire-alsa pipewire-pulse pass htop ncdu neofetch

## Bluetooth Packages
sudo pacman -S bluez bluez-utils bluedevil

## Desktop Packages
sudo pacman -S sddm plasma-desktop kscreen konsole dolphin plasma-pa kde-gtk-config nvidia-settings firefox qtpass qjackctl sddm-kcm plasma-systemmonitor ksystemstats

## VM Packages
sudo pacman -S libvirt edk2-ovmf virt-manager dnsmasq dmidecode qemu swtpm

sudo systemctl enable sddm
