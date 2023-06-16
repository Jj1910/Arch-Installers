#!/bin/bash

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd ~/

yay -S picom-git

sudo cp /etc/xdg/picom.conf.example ~/.config/picom/picom.conf

echo 'backend = "glx";
glx-no-stencil = true;
glx-copy-from-front = false;' >> ~/.config/picom/picom.conf

sudo pacman -S nvidia-settings i3 xorg xorg-xinit nitrogen dmenu alacritty firefox thunar sddm ttf-firacode-nerd pipewire-jack pipewire-alsa pipewire-pulse qjackctl pavucontrol pass cifs-utils polybar

sudo cp /usr/share/doc/alacritty/example/alacritty.yml ~/.config/alacritty/alacritty.yml

touch ~/.xinitrc

echo "nitrogen --restore &
picom &
exec i3" > .xinitrc

echo '[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -vt1' >> ~/.bash_profile

echo "Should be ready to update dot files"