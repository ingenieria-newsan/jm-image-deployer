#!/bin/bash

COLUMNS=$(tput cols) 
title="GRABADO DE IMAGEN SE COMPLETO EXITOSAMENTE" 

# mensaje de exito
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n  Proceda de la siguiente manera:"
printf "\n\n\t 1) Escanee los códigos que se mostrarán a continuación. Podra mostrarlos  \n\t las veces que necesite."
printf "\n\n\t 2) Espere hasta que el equipo se apague completamente. Esto sucede cuando \n\t la pantalla queda en negro y el LED indicador de encendido se apaga."
printf "\n\n\t 3) Una vez que finalice el apagado, disponga el equipo para el embalaje."
printf "\n\n\n PRESIONE '"'Q'"' PARA MOSTRAR LOS CÓDIGOS"
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"

# Espera la tecla q
key=""
read -s -n 1 -p "" key 
while [[ $key != "q" ]] 
do
	read -n1 -s -r -p "" key
done

# muestra los qrs
gnome-terminal --full-screen --hide-menubar --profile qr-ok -- ./qrmac-salida.sh ${1}

# mensaje volver a ver los qrs
clear
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n\n\t PRESIONE '"'L'"' PARA VOLVER A MOSTRAR LOS CODIGOS O 'A' PARA APAGAR"
printf "\n\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"

# espera una tecla
read -s -n 1  -p "" key
while [[ $key != "a" ]]
do
	if [[ $key == "l" ]]
	then
		gnome-terminal --full-screen --hide-menubar --profile qr-ok -- ./qrmac-salida.sh ${1}
	elif [[ $key == "a" ]]
	then
		break
	fi
	read -n 1 -s -r -p "" key
done

# mensaje de apagado
clear
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n\t Espere hasta que la pantalla quede en negro y el LED indicador \n\t de encendido se apague."
printf "\n\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"

# apagado
sleep 3
shutdown now
