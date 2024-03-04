#!/bin/bash

# ASX M06B2 Exercici 2.4 Estructures de control iteratives
# Autor: Rüdiger Wolff

# Declaració de constants i variables
INF=100     # limit inferior
SUP=1000    # limit superior
contInf=0   # contador per a arguments inferior a l'interval
contSup=0   # contador per a arguments superior a l'interval
cont=0      # contador per a arguments dins del rang

# Comprobación del número de argumentos
if [ $# -eq 0 ];then
    echo "ERROR: Número d'arguments incorrecte"
    echo "USAGE: $(basename $0) valor…"
    exit 1
fi

# Bucle for que es repeteix per a cada argument donat
for x in $*; do

    # Comprobació de rang del argument
    if [ $x -lt $INF ];then
        # argument inferior a l'interval
        echo "El valor $x és inferior a l'interval [$INF,$SUP]"
        # aumento del contador inferior
        ((contInf++))
    elif [ $x -gt $SUP ];then
        # argument superior a l'interval
        echo "El valor $x és superior a l'interval [$INF,$SUP]"
        # aumento del contador superior
        ((contSup++))
    else
        # argument dins del rang
        echo "El valor $x és dins del rang [$INF,$SUP]"
        # aumento del contador del rang
        ((cont++))
    fi

done

# Sortida a Stdout
echo "Valors inferiors: $contInf, dins l'interval: $cont, superiors: $contSup"
exit 0
