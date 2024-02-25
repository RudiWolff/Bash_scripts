#!/bin/bash

#El segon script que us demanem pretén que treballeu els iteratius aplicant-ho a la creació de directoris: Volem crear una aula amb alumnes. L’aula, serà una carpeta que es dirà «aula», i contindrà el nombre d’alumnes que l’usuari li haurà indicat, i cadascun d’ells es dirà Alumne_1, Alumne_2 ... Compte si la carpeta aula ja existeix, informeu l’usuari, l’elimineu  i la torneu a crear buida.

# programa que crea un directorio "aula" con subdirectorios "alumnos_1" a 
# "alumnos_n"

echo "Segon script"
echo "--------------"

#cambio al directorio home del usuario
cd ~

# entrada usuario el número de alumnos que hay en clase
echo -n "Quants alumnes hi ha a l'aula? "; read num

# Si existe la carpeta aula borra la carpeta y sus subcarpetas
# Sino existe crea la carpeta aula

if [ -d aula ]
then 
	echo "La carpeta aula existeix i sera eliminada"; rm -r aula
	#else
#	echo "La carpeta aula no existeix i sera creada"
#	mkdir aula;
fi 

# Creación de tantas subcarpetas en carpeta aula cuanto alumnos haya

for ((n=1; n<=num; n++))
do
	mkdir -p aula/Alumne_$n
	# opción -p para que crea también la carpeta aula que ya no existe
done

# Imprime carpetas y subcarpetas en forma de arbol

tree aula/

# End script aula.sh
