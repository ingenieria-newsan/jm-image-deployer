#!/bin/bash

# sonido de error
./sonido-error.sh 

# mensaje de error
COLUMNS=$(tput cols) 
title="ERROR EN EL VOLCADO DE LA IMAGEN"
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n  Proceda de la siguiente manera:"
printf "\n\n\t 1) Verifique que el disco de volcado y que el cargador se encuentren bien conectados."
printf "\n\n\t 2) Si es la primera vez que sucede un fallo, puede reintarlo presionando 'L'."
printf "\n\n\t 3) Si ya reintentó, puede apagar el equipo presionando 'A'."

title="PRESIONE 'L' o 'A' PARA CONTINUAR" 
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"

# espera que se presione una tecla
read -s -n 1  -p "" key
while [[ $key != "l" && $key != "a" ]]
	do
		read -s -n 1  -p "" key
done

# ejecuta una acción en funcion se la tecla presionada
if [ [ $key == "a" ] ]
	then
		gnome-terminal --full-screen --hide-menubar --profile texto-error -- ./error-texto.sh VOLCADO IMAGEN
	elif [ [ $key == "l" ] ]
		then
			sleep .5
fi
