#!/bin/bash

# ASX M06B2 EAC4
# Descripció: Shell script en Bash per fer còpies de seguretat / sincronització 
#             de directoris del sistema
# Autor: Rüdiger Wolff
# Data: 5/12/2023
#  

########  Definicions de variables  ########
backup_path=/backups    # Ruta de la carpeta de còpia de seguretat
retencio=$1             # Els fitxers de còpia de seguretat no poden tenir més de x dies.

# Codis d'error:
ERR_ROOT=1  # L'usuari no és root
ERR_ARG=2   # Arguments no son 2 o mes
ERR_TAR=3   # El programa tar no està instal·lat al sistema
ERR_UEX=4   # Usuari no existeix
ERR_BKU=5   # Ha fallat backup

########  Definicions de funcions  ########
usage (){
    echo >&2 "USAGE: $(basename $0) rentencions login [login...]"
}

error_message(){
    case $1 in
        root)
            echo >&2 "ERROR: Cal ser root per executar el programa"
            usage
            exit $ERR_ROOT
            ;;
        arguments)
            echo >&2 "ERROR: el programa rep almenys 2 arguments"
            usage
            exit $ERR_ARG
            ;;
        no_tar)
            echo >&2 'El programa "tar" no existeix en el sistema. Sortint...'
            exit $ERR_TAR
            ;;
        user)
            echo >&2 "ERROR: login $2 inexistent"
            usage
            ;;
        backup)
            echo >&2 "ERROR: ha fallat la còpia de seguretat de $2"
            status=$ERR_BKU
            ;;
    esac
}

remove_old_files(){
    find $1 -type f -mtime +$2 -iname $3* -exec rm -rf {} \;
}

# Realitza la còpia de seguretat per a cada usuari amb tar amb format nom-aaaammdd.tgz
backup_home(){
    home_dir=$(getent passwd $3 | cut -d: -f6)
    tar -czf $1/$3-$(date +%Y%m%d).tgz $home_dir >& /dev/null || error_message backup $3
}


########  Programari principal  ########

# El programa valida que s’executi com a root.
test $EUID -ne 0 && error_message root

# El programa valida que es reben almenys dos arguments.
test $# -lt 2 && error_message arguments 

# El programa valida si está instalado el programa 'tar'. 
test ! -x $(which tar) && error_message no_tar

# Si el directori destí /backups no existeix, el crea.
test ! -d $backup_path && mkdir $backup_path

# Comprova cada argument per veure si és un usuari existent i 
# referència a funcions , si és el cas.
status=0
until [ $# -eq 1 ];do
        shift
    if [ ! "$(grep "^$1:" /etc/passwd)" ];then
        error_message user $1
        test $status -eq $ERR_BKU || status=$ERR_UEX
    else
        remove_old_files $backup_path $retencio $1
        backup_home $backup_path $retencio $1
    fi
done <<< $*
exit $status



