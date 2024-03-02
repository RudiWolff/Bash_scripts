#!/bin/bash

# ASX M06B2 Exercici 2.3 Estructures condicionals i validació d’arguments
# Autor: Rüdiger Wolff

# Comprobación del número de argumentos
if [ $# -ne 3 ]; then
    echo "ERROR: Número d'arguments incorrecte"
    echo "USAGE: $(basename $0) inf sup valor"
    exit 1
fi

# Validació que el primer argument (inf) és un valor inferior al segon argument (sup). 
# Ha de ser estrictament inferior.
if [ $1 -ge $2 ];then
    echo "ERROR: El valor inf ($1) ha de ser menor que sup ($2)"
    echo "USAGE: $(basename $0) inf sup valor"
    exit 2
fi

# Comprobació si el valor rebut com a tercer argument pertany al rang [inf, sup] (inclòs) o no
if [ $3 -lt $1 ] || [ $3 -gt $2 ];then
    # 3er argument fora del rang
    echo "El valor $3 està fora del rang [$1,$2]"
else
    # 3er argument dins del rang
    echo "El valor $3 està en el rang [$1,$2]"
fi
exit 0
