#!/bin/bash

# En aquest primer script volem que treballeu els condicionals. Volem que
# implementeu un menú amb dues opcions: 

# 1. Comprovar l’existència d’un arxiu
# 2. Comprovar si un directori conté més de 10 arxius.

# En el primer cas ens demanarà la ruta d’un arxiu i el sistema retornarà si existeix o no. En el segon cas ens demanarà la ruta d’un directori i usant les comandes ls i wc (ho podeu fer d’altra manera si preferiu) el sistema ens dirà si conté més de 10 arxius.

# No cal que l’script suporti múltiples consultes. Pot finalitzar després de cada resposta.

cd ~

echo "Primer script"
echo "------------------------"
echo "1: Comprovar l'extistencia d'un arxiu"
echo "2: Comprovar si un directori conte més de 10 arxius"
echo -n "Quina opció vols? "
read opcio

#primera opcion
if [ "$opcio" == 1 ]
	then
		read -p "Indica el path de l'arxiu: " file

		if [ -f $file ]
			then
				echo "L'arxiu existeix"
		else
			echo "L'arxiu no existeix"
		fi

#	segunda opcion
elif [ "$opcio" == 2 ]
	then
		read -p "Indica el path del directori: " folder
		count=$(find $folder -maxdepth 1 -type d | wc -l)
		#manera alternativa de con comando ls (aunque cuenta también las carpetas)
		#count=$(ls $folder | wc -l)
		if [ $count -gt 10 ]
			then
				echo -e "\n------------------------\nHi ha mes de 10 arxius\n------------------------\n"
		else
			echo -e "\n----------------------------------\nHi ha igual o menys de 10 arxius\n----------------------------------\n"
		fi
else 
	echo -e "\nAltre vegada...\n"
fi

echo ""
read -p "Vols fer altre comprovació? [s, o cualquier otra tecla] " new

if [ "$new" == s ]
then
	bash /home/rwolff/Documentos/M01B2_EAC5_scripts/arxiu.sh	
else
	echo -e "\n--------\n| Adèu |\n--------\n"
fi
#en cuanto se mueve el script en otro lugar ya deja de funcionar
# mejor hacer un loop con 'while' con una variable Continuar==true
#cual se define false si el usuario no quiere más comprobaciones.


