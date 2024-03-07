#!/bin/bash

# ASX M06B2 EAC3 
# Autor: Rüdiger Wolff
# Data: 07/11/2023

########  Definicions de variables  ########

# Codis d'error (programa principal):
ERR_ROOT=1  # L'usuari no és root
ERR_ARG=2   # Arguments <> 2 o mes
ERR_OPC=3   # L'opció no és vàlida
# Codis d'error (funcions):
# Funció newUser()
ERR_ALTA_ARG=12     # Arguments de la primera funció <> 1
ERR_ALTA_FTX=13     # Fitxer no existeix
ERR_ALTA_CRT=14     # Error en crear l'usuari o la contrasenya d'usuari
# Funció modGrup()
ERR_GRUP_ARG=22     # Arguments de la segona funció <> 2
ERR_GRUP_EXT=23     # Usuari no existeix
ERR_GRUP_GRP=24     # Grup no existeix
ERR_GRUP_ACT=25     # Grup de l'usuari no s'ha pogut actualitzar.
# Funció idUsers()
ERR_IDENT_ARG=32    # Arguments de la tercera funció >= 2
ERR_IDENT_EXT=33    # Usuari no existeix

########  Definicions de funcions  ########

# Funció newUser per a donar d'alta al sistema.
newUser()
{
# La funció valida que el número d’arguments rebuts sigui correcte (un argument).
if [ ! $# -eq 2 ]; then
    echo >&2 "ERROR: alta ha de rebre exactament un argument (un fitxer)"
    echo >&2 "USAGE: $(basename $0) alta fitxer"
    return $ERR_ALTA_ARG
fi

# La funció valida que l’argument rebut és un fitxer existent (un regular file).
if [ ! -f $2 ];then
    echo >&2 "ERROR: l'argument d'alta ha de ser un fitxer existent"
    echo >&2 "USAGE: $(basename $0) alta fitxer"
    return $ERR_ALTA_FTX
fi

# Generació login y contrasenya
codiReturn=0
# bucle while llegeix el fitxer línia per línia
while read line
do
    # Extracció de les partes necesarias per a la creació del nou usuari 
    # i su contrasenya
    primeraLletra=$(head -c 1 <<< $line)
    cognom1=$(tr ', ' ':' <<< $line | cut -d: -f2)
    fullname=$(cut -d, -f1,2 <<< $line | tr ',' ' ')
    login=$primeraLletra$cognom1   
    password=$(cut -d, -f6  <<< $line)
    
    # creació del nou usuari
    useradd -s /bin/bash -m -d /home/$login $login 2> /dev/null
    chk_useradd=$(echo $?)
    
    # creació de su contrasenya
    chpasswd <<< $login:$password 2> /dev/null
    chk_passwd=$(echo $?)
    
    # Control de resultats
    if [ $chk_useradd -ne 0 ];then
        echo >&2 "Error: $login ($fullname) usuari no creat"
        codiReturn=$ERR_ALTA_CRT
    elif [ $chk_passwd -ne 0 ];then
        echo >&2 "Error: $login password ($password) no assignat"
        codiReturn=$ERR_ALTA_CRT
    else
        echo $login
    fi
done < $2

return $codiReturn
}

# La funció assigna l’usuari al grup com el seu grup principal.
modGroup()
{
# La funció valida que el número d’arguments rebuts sigui correcte (dos arguments).
if [ ! $# -eq 3 ]; then
    echo >&2 "ERROR: grup rep dos arguments: login gid"
    echo >&2 "USAGE: $(basename $0) grup login gid"
    return $ERR_GRUP_ARG
fi

# La funció valida que el primer argument rebut és un login vàlid, un usuari del sistema.
if [ ! $(grep "^$2:" /etc/passwd) ];then
    echo >&2 "ERROR: login $2 inexistent"
    echo >&2 "USAGE: $(basename $0) grup login gid"
    return $ERR_GRUP_EXT
fi

# La funció valida que el segon argument rebut és un grup vàlid del sistema.
if [ ! $(grep ":$3:" /etc/group) ];then
    echo >&2 "ERROR: grup $3 inexistent"
    echo >&2 "USAGE: $(basename $0) grup login gid"
    return $ERR_GRUP_GRP
fi

# Assignació de l’usuari al grup
usermod -g $3 $2 &> /dev/null

# Control de resultats
if [ $? -ne 0 ];then
    echo >&2 "ERROR: $2 -> $3 no actualitzat"
    return $ERR_GRUP_ACT
else
    echo "$2($3)"
fi
}

# La funció itera per cada login rebut com a argument i 
# mostra la informació de l’usuari usant l’ordre id.
idUsers()
{
# La funció valida que el número d’arguments rebuts sigui correcte (un o més arguments).
if [ ! $# -ge 2 ]; then
    echo >&2 "ERROR: ha de rebre un o mes logins"
    echo >&2 "USAGE: $(basename $0) identitats login [login ...]"
    return $ERR_IDENT_ARG
fi

# Processament dels arguments
codiReturn=0
for usuari in $*;do
    if [ ! $usuari == 'identitats' ];then       # Per evitar que la paraula clau s'entengui com a usuari.
        # Per cada usuari cal validar si existeix, si és un usuari vàlid.
        if [ -z "$(grep ^$usuari: /etc/passwd)" ]       # Nota: Les cometes són necessàries
        then                                            # si el resultat de grep conté espais.
            echo >&2 "ERROR: login $usuari inexistent"
            codiReturn=$ERR_IDENT_EXT
        else
            id $usuari
        fi
    fi
done

return $codiReturn
}


########  Programari principal  ########

# El programa valida que s’executi com a root.
if [ $USER != root ];then
    echo >&2 "ERROR: Cal ser root per executar el programa"
    echo >&2 "USAGE: $(basename $0) alta|grup|identitats"
    exit $ERR_ROOT
fi

# El programa valida que es reben almenys dos arguments.
if [ $# -lt 2 ] && 
    [ "$1" != 'alta' ] && 
    [ "$1" != 'grup' ] && 
    [ "$1" != 'identitats' ] 
then
    echo >&2 "ERROR: el programa rep almenys 2 arguments"
    echo >&2 "USAGE: $(basename $0) alta|grup|identitats"
    exit $ERR_ARG
fi

# El programa valida que s’indiqui una de les opcions d’execució vàlides 
# (alta, grup o identitats) e
# Identificació de la funció a ejecutar
case $1 in
    alta )
        newUser $*
        ;;
    grup )
        modGroup $*
        ;;
    identitats )
        idUsers $*
        ;;
    * )
        echo >&2 "ERROR: opció \"$1\" incorrecta. Valides: alta, grup o identitats"
        echo >&2 "USAGE: $(basename $0) alta|grup|identitats"
        exit $ERR_OPC
        ;;
esac
