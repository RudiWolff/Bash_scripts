#!/bin/bash

# ASX M06B2 EAC4
# Shell script en Bash per fer còpies de seguretat / sincronització de directoris del sistema
# Autor: Rüdiger Wolff
# Data: 24/11/2023

########  Definicions de variables  ########
backup_path=/backups    # Ruta de la carpeta de còpia de seguretat
retencio=$1             # Els fitxers de còpia de seguretat no poden tenir més de x dies.

# Codis d'error:
ERR_ROOT=1  # L'usuari no és root
ERR_ARG=2   # Arguments <> 2 o mes
ERR_RET=3   # Primer argument fora de rang
ERR_TAR=4   # El programa tar no està instal·lat al sistema
ERR_UEX=5   # Usuari no existeix

########  Definicions de funcions  ########
usage (){
    echo >&2 "USAGE: $(basename $0) rentencions{0..5} login [login...]"
}

error_message(){
    case $1 in
        root)
        echo >&2 "ERROR: Cal ser root per executar el programa"
        usage
        ;;
        arguments)
        echo >&2 "ERROR: el programa rep almenys 2 arguments"
        usage
        ;;
        retencio)
        echo >&2 "ERROR: El nombre de retencions està fora del rang permès."
        usage
        ;;
        no_tar)
        echo 'El programa "tar" no existeix en el sistema. Sortint...'
        ;;
        user)
        echo >&2 "ERROR: login $2 inexistent"
        usage
        ;;
    esac
}

# Comprova cada argument per veure si és un usuari existent i 
# referència a funcions , si és el cas.
user_exists(){
    codi_return=0
    until [ $# = 1 ];do
        shift 1
        if [ ! "$(grep "^$1:" /etc/passwd)" ];then
            error_message user $1
            codi_return=$ERR_UEX
        else
            remove_old_files $retencio $1
            backup_home $retencio $1
        fi
    done <<< $*
    return $codi_return
}

remove_old_files(){
    find $backup_path -type f -mtime +$retencio -iname $2* -exec rm -rf {} \;
    }

# Realitza la còpia de seguretat per a cada usuari amb tar amb format nom-aaaammdd.tgz
backup_home(){
    tar -czf $backup_path/$2-$(date +%Y%m%d).tgz /home/$2 >& /dev/null
}


########  Programari principal  ########

# El programa valida que s’executi com a root.
test $USER != root && error_message root && exit $ERR_ROOT

# El programa valida que es reben almenys dos arguments.
test $# -lt 2 && error_message arguments && exit $ERR_ARG

# El programa valida que es reb un nombre entre 0 i 5
test $1 -lt 0 -o $1 -gt 5 && error_message retencio && exit $ERR_RET

# El programa valida si está instalado el programa 'tar'. 
test -z $(which tar) && error_message no_tar && exit $ERR_TAR

# Si el directori destí /backups no existeix, el crea.
test ! -d $backup_path && mkdir $backup_path

user_exists $*
