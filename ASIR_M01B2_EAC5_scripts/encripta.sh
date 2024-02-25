#!/bin/bash

#Com a últim exercici, es demana que programeu un codi (script) que xifri una cadena.

#L’script requerirà una cadena d’entrada que serà la cadena a xifrar. La sortida serà una nova cadena, que mostrarem per pantalla i farà la següent transformació: Canviarà només les vocals:
	
#	a → e; 	e → i; 	i→ o; 	o→ u;	u→ a; 

if [ $# == 1 ]
then
	echo -e "Cuarto script\n------------------------\nLa transformació de $1 es $(echo "$1" | tr aeiou eioua)"
else
echo -e "Syntax Error.\nFormat: $0 string"
fi
