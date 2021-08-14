#! /bin/bash
# reproduce un sonido de error y muestra por pantalla los pasos a seguir 
# para apagar la pc y disponerla para el reparador
./sys/sonido-error.sh

COLUMNS=$(tput cols) 
title="UNIDAD RECHAZADA POR ERROR EN ${1} ${2}" 

# mensaje de error
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n  Proceda de la siguiente manera:"
printf "\n\n\t 1) Espere hasta que el equipo se apague completamente. Esto sucede cuando \n\t la pantalla queda en negro y el LED indicador de encendido se apaga."
printf "\n\n\t 2) Identifique el código de rechazo para '${1} ${2}' y escaneelo \n\t con la PC de Ingreso."
printf "\n\n\t 3) Escanee el número de serie en la base del equipo con la PC de Ingreso."
printf "\n\n\t 4) Una vez que finalice los escaneos, disponga el equipo para el reparador."
printf "\n\n\n PRESIONE '"'A'"' PARA APAGAR EL EQUIPO"

# espera presion tecla A
key=""
read -s -n 1 -p "" key 
while [[ $key != "a" ]] 
do
	read -n1 -s -r -p "" key
done

# mensaje de apagado
clear
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n\t Espere hasta que la pantalla quede en negro y el LED indicador \n\t de encendido se apague."
printf "\n\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"

sleep 3
shutdown now
