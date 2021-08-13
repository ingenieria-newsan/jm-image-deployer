#!/bin/bash
./sonido-error.sh 
echo -e
echo -e
echo -e
COLUMNS=$(tput cols) 
title="ERROR EN EL VOLCADO DE LA IMAGEN" 
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo -e
echo -e
echo -e
echo -e
title="PRESIONE '"'L'"' PARA REINTENTAR EL VOLCADO DE LA IMAGEN O '"'A'"' PARA APAGAR" 
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
read -s -n 1  -p "" key
while [[ $key != "l" && $key != "a" ]]
do
	read -s -n 1  -p "" key
done
if [[ $key == "l" ]]
then
	sudo /usr/sbin/ocs-sr -g auto -e1 auto -e2 -r -j2 -batch -scr -p true restoredisk JM-v1002 $huayra     #descomentar
	sudo timeout 1.5 speaker-test --frequency 500 --test sine > /dev/null 2>&1
	linea="Program terminated"
	error="Program terminated"
	if [ -e /var/log/clonezilla.log ]
	then
		linea=$(tail -1 /var/log/clonezilla.log | cut -d'!' -f 1)
	fi
	if [ "$linea" == "$error" ]
	then
		gnome-terminal --full-screen --hide-menubar --profile texto -- ./error-volcado.sh
	else
		gnome-terminal --full-screen --hide-menubar --profile texto-ok -- ./ok-texto.sh $ubuntu
	fi
elif [[ $key == "a" ]]
then
	gnome-terminal --full-screen --hide-menubar --profile texto-error -- ./error-texto.sh VOLCADO IMAGEN	
fi

