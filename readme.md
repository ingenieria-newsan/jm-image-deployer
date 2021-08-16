# Volvado de imagen
Realiza el volcado de imagen final del cliente luego de verificar versión de BIOS, y aprovisionamiento.

## Compativilidad
- NOBLEX SF20GM7 ( Proyecto Juana Manso )

## Dependencias
- gnome-terminal
- clonezilla
- jm-provition-monitor

## Instalación
Siga los siguientes pasos para instalar el sistema:

1. Clone el repositorio actual en `/home`.
2. Asigne permiso de ejecución: `sudo chmod +x /home/jm-image-deployer/*.sh /home/jm-image-deployer/sys/*.sh`
3. Copie el archivo `./iniciar.sh` en el escritorio.
4. Copir el archivo `./update` en el directorio `/home`.
5. Instale las dependencias.
6. Agregue `/iniciar.sh` en la lista de auto-arranque.

## Update
Para actualizar la solución siga los siguientes pasos:

1. Bootee en un equipo compatible usando el disco de volcado.
2. Cancela la ejecucion de los procesos precionando `Alt` + `F4`.
3. Habra una terminal y posicionese en el directorio `/home`.
4. Ejecute el comando `sudo ./update.sh`.
5. Espere que el proceso finalice y apague el equipo.  
