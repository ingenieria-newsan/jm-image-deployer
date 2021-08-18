#! /bin/bash

# instalar dependencias
sudo apt-get install clonezilla
sudo apt-get install gnome-terminal
sudo apt-get install qrencode

# configurar inicio automatico

# impotar perfiles de gnome-terminal
dconf load /org/gnome/terminal/legacy/profiles:/ < ./res/gnome-terminal-profiles.dconf
