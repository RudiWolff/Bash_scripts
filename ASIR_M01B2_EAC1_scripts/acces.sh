#!/bin/bash

# En aquest tercer script, volem que treballeu l’accés a fitxers. Es demana que programeu un script que requereixi 2 arguments: el primer serà un arxiu que contindrà noms (sense espais), un per línia. El segon argument serà un nom d’usuari.

# El vostre guió comprovarà que el nombre d’arguments proporcionats és l’esperat (2) i posteriorment informarà del nombre de vegades que el nom d’usuari (segon paràmetre) apareix dins l’arxiu (primer paràmetre).

# Format del comando: script.sh file "nom d'usuari"

#El sript debe esperar 2 argumentos, si recibe más o menos avisa al usuario que hay error
#de sintaxis.

if [ $# == 2 ]
then

	echo -e "\nTercer script\n--------------------------\n"

#Primera opción de if	

#Variable x es igual que: cat lee el fichero que se ha llamado por el argumento 1 del script,
#grep filtra la lista de cat con el argumento 2 del comando en el terminal y
#wc cuenta con -l las líneas de salida de grep, con -w cuenta las palabras 

	echo -e "El nombre de usuario $2 aparaece $(cat $1 | grep $2 | wc -w) veces en el fichero $1\n"
	
else
	echo -e " syntax error.\nFormat: acces.sh filename string\n try it again."	
fi 
	
