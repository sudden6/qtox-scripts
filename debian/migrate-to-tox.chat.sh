#! /bin/sh

checkExit() {
    if [ ! $? -eq 0 ] ; then
      echo "Ein Fehler ist aufgetreten. (Fehlercode $?)";
      exit 1;
    fi
}

askContinue() {
    while true; do
        read -p "$1 (j/n)" yn
        case $yn in
            [Jj]* ) break;;
            [Nn]* ) echo 'Abgebrochen.'; exit 2;;
            * ) echo 'Bitte drücke "j" (ja) oder (n)ein antworten."';;
        esac
    done
}

echo "\n\n\nBITTE LIES DEN FOLGENDEN HINWEIS BEVOR DU WEITERMACHST!!!\n\n\n"

echo "Hallo $USER!\n"
echo 'Aus organisatorischen Gründen hat sich die Internet-Adresse (Basisdomain) des Tox Projektes geändert. Dieses Skript ersetzt das installierte QTox mit einer aktualisierten Version. Die alte Adresse (Basisdomäne) "tox.im" ist NICHT MEHR GÜLTIG und wurde durch "tox.chat" ersetzt.'
echo ''
echo 'Mehr Details zum Thema findest Du in folgendem (englischen) Blogeintrag:
https://blog.tox.chat/2015/07/current-situation-3/'
echo ''
echo '----- BESCHREIBUNG -----
Das Skript nimmt folgende Änderungen an Deinem System vor:
Schritt 1: QTox wird zunächst deinstalliert!
Schritt 2: Der Installationsschlüssel wird ersetzt.
           (siehe https://pkg.tox.chat/pubkey.gpg)
Schritt 3: Die APT Paketquellen werden aktualisiert.
Schritt 4: Auf Wunsch wird QTox installiert.
-------------------------
'


askContinue 'Zum weitermachen benotigst Du Dein Passwort. Weiter?' ; checkExit


echo 'Entferne QTox, falls vorhanden...'
sudo apt-get purge -y qtox ; checkExit

#remove old key
echo 'Entferne den alten Installationsschlüssel (0C2E03A0)...'
sudo apt-key del 0C2E03A0 ; checkExit
 
echo 'Ersetze die Datei /etc/apt/sources.list.d/tox.list (enthält die neue APT-Paketquelle)'
sudo sh -c 'echo "deb https://pkg.tox.chat/ nightly main" > /etc/apt/sources.list.d/tox.list' ; checkExit

echo 'Hole und registriere den neuen Installationsschlüssel von https://pkg.tox.chat/pubkey.gpg ...'
wget -qO - https://pkg.tox.chat/pubkey.gpg | sudo apt-key add - ; checkExit

echo 'Aktualisiere die APT-Paketquellen. Das kann einige Minuten dauern...'
sudo apt-get update -qq ; checkExit

echo 'Installiere für Tox notwendige Pakete...'
sudo apt install -y apt-transport-https ; checkExit
echo 'Die Tox Paketquelle (PPA) wurde installiert.'

askContinue 'Soll ich das neue QTox installieren?'
sudo apt install -y qtox ; checkExit


echo ''
echo '-------------------------'
echo ''

echo 'Glückwunsch! QTox wurde erfolgreich aktualisiert.'
