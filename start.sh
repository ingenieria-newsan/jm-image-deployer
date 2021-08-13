#! /bin/bash

# directorio de trabajo
SCRIPT=$(readlink -f $0);
dir_base=`dirname $SCRIPT`;

# chequea que nombre tiene el disco de ubuntu y el de huayra
printf '[ INFO ] Detectando discos...\n'
ubuntu=$(lsblk -no pkname $(findmnt -n / | awk '{ print $2 }'))
huayra="sda"
if [ $ubuntu == $huayra ]
	then
		huayra="sdb"
		printf "[ INFO ] Discos: Live=${ubuntu^^} Destino=${huayra^^}.\n"
fi

sleep .5

# monta la particion donde se encuentra la imagen del a volcar en /home/partimag
printf '[ INFO ] Montando particiones...\n'
sudo umount /dev/${ubuntu}3
sudo mount /dev/${ubuntu}3 /home/partimag > /dev/null 2>&1
sudo umount /jmdisk > /dev/null 2>&1
sudo mkdir /jmdisk > /dev/null 2>&1
sudo mount /dev/${huayra}3 /jmdisk

sleep .5

# calcula los hash, seteamos hash para no tener errores en la comparacion, si existe el archivo test.txt se toma el contenido de este
printf '[ INFO ] Validando hash...\n'
cd $dir_base
hash_equipo=$(./sys/hash.sh)
hash_archivo="archivo_no_encontrado"

if [ -e /jmdisk/SHA1/test.txt ]
	then
		hash_archivo=$(cat /jmdisk/SHA1/test.txt)
	else
		printf '[ INFO ] Archivo hash SHA1 no encontrado.\n'	
		#hash_archivo=$(cat /SHA1/debug.txt)
fi

sleep .5

# compara los hash de equipo y archivo, si hubo un volcado trunco de la imagen
hash_check=false
if [ $hash_equipo = $hash_archivo ]
	then
		printf '[ INFO ] Validación de HASH correcta.\n'
		hash_check=true
	else
		printf '[ WARN ] Falló la validación de hash. Verificando particiones...\n'
		printf "[ INFO ] archivo = ${hash_archivo} \n[ INFO ] equipo = ${hash_equipo} \n" # muestra los hash a los fines de hacer debug
		
		if [ $(grep -c $huayra /proc/partitions) = 6 ]
			then
				printf '[ INFO ] Se detectó particionado de un intento anterior de volcado.\n'
				hash_check=true
			else
				printf '[ WARN ] Falló la validación por particionado.\n'
				hash_check=false
				gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-texto.sh RUNNING TEST
		fi
fi

sleep .5

# desmonta el disco donde se encuentra el flag del running
sudo umount /jmdisk > /dev/null 2>&1

sleep .5

# chequea la version actual de la BIOS con la que se le da por parametro en el archivo 
bios_check=false
if [ $(cat $dir_base/versiones/bios.version) = $(sudo dmidecode -s bios-version) ]
	then
		printf '[ INFO ] Validación de BIOS correcta.\n'
		bios_check=true
	else
		printf '[ WARN ] Falló la validación de BIOS.\n'
		bios_check=false
		gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-texto.sh BIOS
fi

sleep .5

# main process
if [ $hash_check == "true" ] &&  [ $bios_check == "true" ]
	then
		
		# valida que la bateria esté conectada
		bateria=$(cat /sys/class/power_supply/ADP1/online) #bateria=$(cat /sys/class/power_supply/ACAD/online)
		if [ $bateria != 1 ]
			then
				printf '[ WARN ] Falta conexión a alimentación externa\n'
				gnome-terminal --full-screen --hide-menubar --profile texto-error --wait -- ./sys/error-bateria.sh
			else
				printf '[ INFO ] Conexión a alimentación externa detectada\n'
		fi
		
		# aprovisionamiento del equipo
		printf '[ INFO ] Iniciando aprovisionamiento...\n'
		gnome-terminal --full-screen --hide-menubar --profile texto --wait -- /home/jm-provition-monitor/monitor.sh
		printf '[ INFO ] Aprovisionamiento finalizado\n'
				
		# mensaje volcado de imagen
		printf '[ INFO ] Iniciando volcado de imagen...\n'
	
		# mensaje para apagado de modo incorrecto
		COLUMNS=$(tput cols) 
		text="ERROR EN EL APAGADO DEL EQUIPO"
		printf "\n\n\n \033[5;30m %*s \033[0m \n" $(((${#text}+$COLUMNS)/2)) "$text"
		printf "\n\n\t Por favor apaguelo manualmente manteniendo presionado el boton \n\t de apagado durante 5 segundos \n"
		
		# volcado de imagen
		gnome-terminal --full-screen --hide-menubar --profile texto --wait -- ./sys/volcado.sh $huayra

		#una vez terminada la clonacion chequeamos que el log de salida no sea error e imprimimos la mac
		linea="Program terminated"
		error="Program terminated"
		
		# recuperamos la ultima linea del log de salida para ver si se completo correctamente
		if [ -e /var/log/clonezilla.log ]
			then
				linea=$(tail -1 /var/log/clonezilla.log | cut -d'!' -f 1)
		fi
		
		# valida si hay un error y muestra el mensaje correspondiente
		if [ "$linea" == "$error" ]
			then
				gnome-terminal --full-screen --hide-menubar --profile texto --wait -- ./sys/error-volcado.sh
			else
				gnome-terminal --full-screen --hide-menubar --profile texto-ok --wait -- ./sys/ok-texto.sh $ubuntu
		fi
	
	else
		printf "[ WARN ] Faltan validaciones requeridas: hash_check=$hash_check bios_check=$bios_check"

fi

sleep 3600
