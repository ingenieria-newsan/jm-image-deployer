#! /bin/bash

# eliminar
sudo rm -rf ./jm-provition-monitor
sudo rm -rf ./jm-image-deployer
sleep 1

# descargar
sudo git clone https://github.com/jcvels/jm-provition-monitor
sudo git clone https://github.com/jcvels/jm-image-deployer
sleep 1

# permisos
sudo chmod +x ./jm-provition-monitor/*.sh
sudo chmod +x ./jm-provition-monitor/res/*.*
sudo chmod +x ./jm-provition-monitor/res/*

sudo chmod +x ./jm-image-deployer/*.sh
sudo chmod +x ./jm-image-deployer/sys/*.sh
sleep 1
