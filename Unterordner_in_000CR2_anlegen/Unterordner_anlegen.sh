#! /bin/bash
# Autor: Rüdiger Wolff
# Datum: 12.9.2024
# Skript für die Erstellung der typischen Unterordner zur Sicherung der Bilder:
# - EM-5
# - Handyfotos
# - TG-6 

# Definition der Unterordner als Array
unterordner=("EM-5" "Handyfotos" "TG-6")

# Auswahl des Zielordners
# >> Im Zielordner kann über die Funktionalität des Dateimanagers
# >> ein vorhandener Ordner ausgewählt oder
# >> ein neuer Ordner angelegt werden.
zielordner=$(zenity --file-selection --directory --title="Ordner wählen") 

cd "$zielordner"

# Erstellen der Unterordner im Zielordner
mkdir ${unterordner[@]}

# Es wird ein Dateimanager-Fenster im Zielordner geöffnet
nautilus .
