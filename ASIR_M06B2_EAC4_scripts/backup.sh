#!/bin/bash

# ASX M06B2 EAC4 Planificació i Automatització de Tasques 
# Descripció: Shell script per fer còpies de seguretat / sincronització 
#             de directoris del sistema
# Autor: Rüdiger Wolff
# Data: 5/12/2023
# -----------------------------------------------------------------------

########  Definicions de variables  ########
backup_path=/backups    # Ruta de la carpeta de còpia de seguretat

########  Definicions de funcions  ########
# Realitza la còpia de seguretat per a cada usuari amb tar amb format nom-aaaammdd.tgz
backup_home(){
    home_dir=$(getent passwd $2 | cut -d: -f6)
    tar -czf $1/$2-$(date +%Y%m%d).tgz $home_dir >& /dev/null
    return $?
}

########  Programari principal  ########

# El programa valida que s’executi com a root.
if [ $EUID -ne 0 ];then
    echo >&2 "ERROR: Cal ser root per executar el programa"
    echo >&2 "USAGE: $(basename $0) rentencions login [login...]"
    exit 1
fi

# El programa valida que es reben almenys dos arguments.
if [ $# -lt 2 ];then 
    echo >&2 "ERROR: el programa rep almenys 2 arguments"
    echo >&2 "USAGE: $(basename $0) rentencions login [login...]"
    exit 2 
fi

# El programa valida si está instalado el programa 'tar'.
tar_exists=$(which tar)
if [ -z "$tar_exists"  ];then
    echo >&2 'El programa "tar" no existeix en el sistema. Sortint...'
    exit 3
fi

# Si el directori destí /backups no existeix, el crea.
if [ ! -d $backup_path ];then
    mkdir $backup_path
fi

# Comprova cada argument per veure si és un usuari existent i 
# referència a funcions , si és el cas.
retencio=$1     # Els fitxers de còpia de seguretat no poden tenir més de x dies.
status=0

shift
for login in $*
    do
    # L'argument rebut es un login valid 
    grep -q "^$login:" /etc/passwd &> /dev/null
    if [ $? -ne 0 ];then
        echo >&2 "ERROR: login $login inexistent"
        echo >&2 "USAGE: $(basename $0) rentencions login [login...]"
        # En el cas que la còpia de seguretat d'un usuari ja hagi produït
        # un error (funció backup_home), es conservarà status major.
        if [ $status -ne 5 ];then
            status=4
        fi
    else
        # Es purga totes les còpies més antigues que dies especificats per retenció.
        find $backup_path -type f -mtime +$retencio -iname $login* -delete
        # Es fa la còpia de seguretat.
        backup_home $backup_path $login
        if [ $? -ne 0 ];then
            echo >&2 "ERROR: ha fallat la còpia de seguretat de $login"
            status=5
        fi
    fi
done
exit $status

