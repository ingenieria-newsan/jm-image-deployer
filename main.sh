#! /bin/bash

clear
m_pass='\033[1;32m PASS \033[0m' # ${m_pass}
m_fail='\033[1;31m FAIL \033[0m' # ${m_fail}
m_warn='\033[1;34m WARN \033[0m' # ${m_warn}
m_info='\033[1;36m INFO \033[0m' # ${m_info}

# directorio de trabajo
SCRIPT=$(readlink -f $0);
dir_base=`dirname $SCRIPT`;

# chequea que nombre tiene el disco de ubuntu y el de huayra
printf "[${m_info}] Detectando discos...\n"
ubuntu=$(lsblk -no pkname $(findmnt -n / | awk '{ print $2 }'))
huayra="sda"

if [ $ubuntu == $huayra ]
	then
		huayra="sdb"
fi

printf "[${m_info}] Discos: deploy=${ubuntu} target=${huayra}.\n"

sleep .5

# monta la particion donde se encuentra la imagen del a volcar en /home/partimag
printf "[${m_info}] Montando particiones...\n"
sudo umount /dev/${ubuntu}3
sudo mount /dev/${ubuntu}3 /home/partimag > /dev/null 2>&1
sudo umount /jmdisk > /dev/null 2>&1
sudo mkdir /jmdisk > /dev/null 2>&1
sudo mount /dev/${huayra}3 /jmdisk

sleep .5

# calcula los hash, seteamos hash para no tener errores en la comparacion, si existe el archivo test.txt se toma el contenido de este
printf "[${m_info}] Validando hash...\n"
cd $dir_base
hash_equipo=$(./sys/hash.sh)
hash_archivo="archivo_no_encontrado"

if [ -e /jmdisk/SHA1/test.txt ]
	then
		hash_archivo=$(tr -dc '[[:print:]]' <<< "$(cat /jmdisk/SHA1/test.txt)")   
	else
		printf "[${m_info}] Archivo hash SHA1 no encontrado.\n"
fi

sleep .5

# compara los hash de equipo y archivo, si hubo un volcado trunco de la imagen
hash_check=false
if [ $hash_equipo = $hash_archivo ]
	then
		printf "[${m_info}] Validación de HASH correcta.\n"
		hash_check=true
	else
		printf "[${m_warn}] Falló la validación de hash. Verificando particiones...\n"
		printf "[${m_info}] a=${hash_archivo} \n[${m_info}] e=${hash_equipo} \n" # muestra los hash a los fines de hacer debug
		
		if [ $(grep -c $huayra /proc/partitions) = 6 ]
			then
				printf "[${m_info}] Se detectó particionado de un intento anterior de volcado.\n"
				hash_check=true
			else
				printf "[${m_warn}] Falló la validación por particionado.\n"
				hash_check=false
				gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-generico.sh RUNNING TEST
		fi
fi

sleep .5

# desmonta el disco donde se encuentra el flag del running
sudo umount /jmdisk > /dev/null 2>&1

sleep .5

# chequea la version actual de la BIOS con la que se le da por parametro en el archivo
printf "[${m_info}] Validando bios...\n"
bios_check=false
if [ $(cat $dir_base/versiones/bios.version) = $(sudo dmidecode -s bios-version) ]
	then
		printf "[${m_info}] Validación de BIOS correcta.\n"
		bios_check=true
	else
		printf "[${m_warn}] Falló la validación de BIOS.\n"
		bios_check=false
		gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-generico.sh BIOS
fi

sleep .5

# main process
if [ $hash_check == "true" ] &&  [ $bios_check == "true" ]
	then
		
		# valida que la bateria esté conectada
		bateria=$(cat /sys/class/power_supply/ADP1/online) #bateria=$(cat /sys/class/power_supply/ACAD/online)
		if [ $bateria != 1 ]
			then
				printf "[${m_warn}] Falta conexión a alimentación externa\n"
				gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-bateria.sh
			else
				printf "[${m_info}] Conexión a alimentación externa detectada\n"
		fi
		
		# aprovisionamiento del equipo
		printf "[${m_info}] Iniciando aprovisionamiento...\n"
		gnome-terminal --full-screen --hide-menubar --profile texto --wait -- /home/jm-provition-monitor/monitor.sh
		printf "[${m_info}] Aprovisionamiento finalizado\n"

		# mensaje volcado de imagen
		printf "[${m_info}] Iniciando volcado de imagen...\n"
	
		# mensaje para apagado de modo incorrecto
		COLUMNS=$(tput cols) 
		text="ERROR EN EL APAGADO DEL EQUIPO"
		printf "\n\n\n \033[5;31m %*s \033[0m \n" $(((${#text}+$COLUMNS)/2)) "$text"
		printf "\n\n\t Por favor apaguelo manualmente manteniendo presionado el boton \n\t de apagado durante 5 segundos \n\n\n"
		
		# bucle de volcado y control de imagen		
		image_check=false
		image_counter=0

		while [ $image_check == "false" ]
			do
				# contador de errores y borrado de log previo
				error_counter=0
				if [ -e /var/log/clonezilla.log ]
					then
						sudo rm -f /var/log/clonezilla.log
						printf "[${m_info}] Se eliminó correctamente el log anterior de Clonezilla.\n"
				fi

				# volcado de imagen
				printf "[${m_info}] Iniciando volcado de imágen.\n"
				gnome-terminal --full-screen --hide-menubar --profile texto --wait -- ./sys/volcado.sh $huayra
				printf "[${m_info}] Volcado de imágen finalizado.\n"

				#validaciones
				printf "[${m_info}] Iniciando validaciones...\n"

				# validación de particiones
				if [ $(grep -c $huayra /proc/partitions) = 6 ]
					then
						printf "[${m_pass}]"
					else
						printf "[${m_fail}]"
						error_counter=$((error_counter+1))
				fi
				printf " Particiones en disco de destino.\n"

				sleep .5

				# validafion finalizacion del proceso Clonezilla
				if [ -e /var/log/clonezilla.log ]
					then
						if [ $(cat /var/log/clonezilla.log | grep -c "Ending /usr/sbin/ocs-sr at" ) = 1 ]
							then
								printf "[${m_pass}]"
							else
								printf "[${m_fail}]"
								error_counter=$((error_counter+1))
						fi
					else
						printf "[${m_fail}]"
						error_counter=$((error_counter+1))
				fi
				printf " Finalización del proceso Clonezilla.\n"
				sleep .5

				# validafion errores del proceso Clonezilla
				if [ -e /var/log/clonezilla.log ]
					then
						if [ $(tail -1 /var/log/clonezilla.log | cut -1 -d'!' -f 1 | grep -c "Program terminated" ) = 0 ]
							then
								printf "[${m_pass}]"
							else
								printf "[${m_fail}]"
								error_counter=$((error_counter+1))
						fi
					else
						printf "[${m_fail}]"
						error_counter=$((error_counter+1))
				fi
				printf " Control de errores en proceso Clonezilla.\n"
				sleep .5
			
				# valida si hay un error y muestra el mensaje correspondiente
				printf "[${m_info}] Errores encontrados = ${error_counter}\n"
				if [ $error_counter != 0 ]
					then
						image_counter=$((image_counter+1))
						gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-volcado.sh $image_counter
					else
						gnome-terminal --full-screen --hide-menubar --profile texto-ok --wait -- ./sys/volcado-ok.sh $ubuntu
						image_check=true
				fi

				# mensaje para apagado de modo incorrecto
				COLUMNS=$(tput cols) 
				text="ERROR EN EL APAGADO DEL EQUIPO"
				printf "\n\n\n \033[5;31m %*s \033[0m \n" $(((${#text}+$COLUMNS)/2)) "$text"
				printf "\n\n\t Por favor apaguelo manualmente manteniendo presionado el boton \n\t de apagado durante 5 segundos \n\n\n"

			done
	else
		printf "[${m_warn}] Faltan validaciones requeridas: hash_check=$hash_check bios_check=$bios_check"
fi
printf "[${m_fail}] Si está viendo esto es porque algo NO sucedio según lo esperado.\n"
sleep 3600
shutdown now
