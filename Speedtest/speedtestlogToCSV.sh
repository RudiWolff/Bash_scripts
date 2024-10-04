#! /bin/bash

# Autor: Rüdiger Wolff
# Datum: 3/10/2024
# Das Programm transformiert die Daten, die vom Speedtest-Skript in einem log gesammelt werden,
# in eine Tabelle, die das csv-Format respektiert.
# Ziel ist es mit Hilfe von Programmen Dritter die Leistung des Internet-Anbieters Orange
# in einer Grafik zu veranschaulichen.

# Prüfung auf Argument
if [ $# -ne 1 ]
then
    echo "Das Skript braucht eine Datei als Eingabe (z.B. /var/log/Arbeit/speedtest.log)."
    exit 1
fi

# Entfernt alle Zeilenumbrüche
tr -d '\n' < $1 > aux.file
#echo -e "\n" >> aux.file

# Entferne überflüssige Zeichen
tr -s '=' < aux.file > aux.file1

# Neue Zeilenumbrüche
tr '=' '\n' < aux.file1 > aux.file2

# Entferne erste Zeile aus aux.file2
sed -i '1d' aux.file2

# Entferne Ketten an Leerzeichen
tr -s ' ' < aux.file2 > aux.file3
#rm aux.file2

# Die gesamte Datei in einen Array einlesen
readarray -t speedlog < aux.file3
#rm aux.file4

# Erzeugung der csv-Datei
# Header
echo -e "Datum?Uhrzeit?Idle Latency (ms)?Download (Mbps)?Upload (Mbps)" > speedtest.csv

# Zeilenweise Bearbeitung. Erzeugt tabulatorgetrennte Liste
for line in "${speedlog[@]}"; do
  # process the lines
  echo -n $line | cut -d' ' -f5-8,10,12,14 | tr ' ' '?' | sed -e 's/\./,/g' >> speedtest.csv
done

# In erzeugter csv-Datei die Datumsangabe korregieren
sed -i -e '2,$ s_?_/_' -e '2,$ s_?_/_' speedtest.csv

# Die Hilfsdateien löschen
rm aux.file*

# Die gesamte Datei in einen Array einlesen
readarray -t csv < speedtest.csv
# Den Namen des Monats durch dessen Zahl ersetzen
for zeile in "${csv[@]}"; do
    # processing
    zAnfang=$(echo $zeile | cut -d'?' -f1)
    if [ $zAnfang = "Datum" ]; then
        echo $zeile > hilfsdatei
    else
        month=$(echo $zeile | cut -d'/' -f2)
        case $month in 
            sep )   var=09;;
            oct )   var=10;;
            nov )   var=11;;
            dec )   var=12;;
            jan )   var=01;;
            feb )   var=02;;
            mar )   var=03;;
            apr )   var=04;;
            may )   var=05;;
            jun )   var=06;;
            jul )   var=07;;
            aug )   var=08;;
        esac
        echo $zeile | sed "s/$month/$var/" >> hilfsdatei
    fi
done

# Trennzeichen '?' durch Tabulator ersetzen
tr '?' '\t' < hilfsdatei > speedtest.csv

rm hilfsdatei
