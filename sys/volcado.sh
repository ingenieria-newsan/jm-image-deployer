#! /bin/bash

# mensaje para apagado de modo incorrecto
COLUMNS=$(tput cols) 
text="ERROR EN EL APAGADO DEL EQUIPO"
printf "\n\n\n \033[5;31m %*s \033[0m \n" $(((${#text}+$COLUMNS)/2)) "$text"
printf "\n\n\t Por favor apaguelo manualmente manteniendo presionado el boton \n\t de apagado durante 5 segundos \n\n\n"

# volcado de imagen
sudo /usr/sbin/ocs-sr -g auto -e1 auto -e2 -r -j2 -batch -scr -p true restoredisk JM-v1002 ${1} 

#### DEBUG !!

    # printf "\n\t CLONADO DUMMY --- JUST WAIT 10s..."
    # sleep 10

#### DEBUG !!

# aviso sonoro de que finalizo el proceso
sudo timeout 1.5 speaker-test --frequency 500 --test sine > /dev/null 2>&1
