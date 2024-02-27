#!/bin/bash

# ASX M06B2 EAC2 Exercici 2.2 "dos_arguments.sh login short|long"
# Autor: Rüdiger Wolff

# Numero de argumentos valido
if [ $# -ne 2  ]; then
    echo -e "ERROR: Número d'aguments incorrecte\nUSAGE: $(basename $0) login short|long"
    exit 1
fi

# Segon argument existe i es o bé 'short' o 'long'
if [ -n $2  ]; then
    if [ $2 != "short" ] && [ $2 != "long" ]; then
            echo -e "ERROR: Format del segon argument no vàlid, ha de ser 'short' o 'long'"
        echo "USAGE: $(basename $0) login short|long"
            exit 2
    fi
fi

# Primer argument ha de ser un login (nom d’usuari) vàlid
if [ -z $(cut -f1 -d: /etc/passwd | grep $1) ]; then
    echo "ERROR: Usuari $1 inexistent"
    exit 3
fi

# El programa ha de mostrar el login, uid, gid, gname, home i existència-del-home de l’usuari rebut com argument (sense funcions)
# Declaració de variables
LOGIN=$(grep ^$1: /etc/passwd | cut -f1 -d:)
U1D=$(grep ^$1: /etc/passwd | cut -f3 -d:)
GID=$(grep ^$1: /etc/passwd | cut -f4 -d:)
GNAME=$(grep :$(grep ^$1: /etc/passwd | cut -f4 -d:): /etc/group | cut -f1 -d:)        # Nota: grep :GID: /etc/group | cut ...
H0M3=$(grep ^$1: /etc/passwd | cut -f7 -d:)
DIR=$(grep ^$1: /etc/passwd | cut -f6 -d:)
if [  -d $DIR ]; then
    EXIST="<existent>"
else
    EXIST="<inexistent>"
fi

# Opció 'short'
if [ $2 = short ]; then
    echo $LOGIN $U1D $GID $GNAME $H0M3 $EXIST

# Opció 'long'
else
    # Anzeige in long-Format
    echo login: $LOGIN 
    echo uid: $U1D 
    echo gid: $GID 
    echo gname: $GNAME 
    echo home: $H0M3 
    echo $EXIST
fi
exit 0
