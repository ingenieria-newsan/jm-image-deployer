#! /bin/bash

# instalar dependencias
sudo apt-get install clonezilla
sudo apt-get install gnome-terminal

# configurar inicio automatico

# impotar perfiles de gnome-terminal
dconf load /org/gnome/terminal/legacy/profiles:/ < ./res/gnome-terminal-profiles.dconf

# configurar update
cp /home/newsan/jm-image-deployer/update.sh /home/newsan/update.sh

# configurar wallpaper
gsettings get org.gnome.desktop.background picture-uri 'file:///home/newsan/jm-image-deployer/res/newsan.png'
