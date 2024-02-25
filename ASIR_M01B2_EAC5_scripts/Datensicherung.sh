#!/bin/bash

#löscht den Ordner M01B2_EAC5_scripts auf meinem Windowsrechner
#kopiert danach den gleichen Ordner wieder in den geteilten Windwosordner

if [ -d /media/M01B2_EAC5_scripts  ]
then
	rm -R /media/M01B2_EAC5_scripts
fi

cp -R /home/rwolff/Documentos/M01B2_EAC5_scripts /media/M01B2_EAC5_scripts
