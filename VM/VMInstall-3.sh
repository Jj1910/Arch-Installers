#!/bin/bash

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si

yay -S picom-git

cd ~/

cp /etc/xdg/picom.conf.example ~/.config/picom/picom.conf

sudo pacman -S i3 xorg xorg-xinit nitrogen dmenu alacritty firefox thunar gvim sddm pipewire-jack pipewire-alsa pipewire-pulse qjackctl pavucontrol pass polybar ttf-firacode-nerd

mkdir ~/.config/alacritty

cp /usr/share/doc/alacritty/example/alacritty.yml ~/.config/alacritty/alacritty.yml

touch .xinitrc

echo "nitrogen --restore &
picom &
exec i3" >> .xinitrc

echo "[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -vt1" >> .bash_profile

sudo systemctl enable --now sddm
