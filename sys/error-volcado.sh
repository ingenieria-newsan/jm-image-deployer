#!/bin/bash

# sonido de error
./sys/error-sonido.sh &

# mensaje de error
clear
COLUMNS=$(tput cols) 
title="ERROR EN EL VOLCADO DE LA IMAGEN (${1})"
printf "\n\n \033[1;30m %*s \033[0m \n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "\n\n  Proceda de la siguiente manera:"
printf "\n\n\t 1) Verifique, SIN deconectar, que el disco de volcado se encuentre bien \n\t conectado."
printf "\n\n\t 2) Si el disco está bien conectado, y es la primera vez que sucede un \n\t fallo, puede reintarlo presionando 'L'."
printf "\n\n\t 3) Si ya reintentó anteriormente, o detectó una mala conexión apague el \n\t equipo presionando 'A' y dispongalo para el reparador."

text="PRESIONE 'L' o 'A' PARA CONTINUAR" 
printf "\n\n\n %*s \n" $(((${#text}+$COLUMNS)/2)) "$text"

# espera que se presione una tecla
read -s -n 1 -p "" key
while [ [ $key != "l" && $key != "a" ] ]
	do
		read -s -n 1 -p "" key
done

# ejecuta si se presiono a
if [ [ $key == "a" ] ]
	then
		gnome-terminal --full-screen --hide-menubar --profile texto-error -- ./sys/error-generico.sh VOLCADO IMAGEN
fi

# ejecuta si se presiono l
if [ [ $key == "l" ] ]
	then
		sleep .5
fi
