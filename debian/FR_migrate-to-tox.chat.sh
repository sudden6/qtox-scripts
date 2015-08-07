#! /bin/sh

checkExit() {
    if [ ! $? -eq 0 ] ; then
      echo "Une erreur s'est produite. (Erreur n. $?)";
      exit 1;
    fi
}

askContinue() {
    while true; do
        read -p "$1 (O/n)" on
        case $on in
            [On]* ) break;;
            [Nn]* ) echo 'Annulé.'; exit 2;;
            * ) echo 'Êtes-vous sûr(e) ? (O/n) ';;
        esac
    done
}

echo "\n\n\nMERCI DE LIRE LES NOTES CI-DESSOUS AVANT DE CONTINUER !!!\n\n"

echo "Bonjour $USER !\n"
echo "Pour des questions d'organisation, l'URL officiel du Projet Tox a changé de 'tox.im' vers 'tox.chat'.
Ce script remplace la version actuelle de qTox avec celle du nouveau dépôt APT officiel.\n"
echo "Vous pourrez trouver plus d'informations à propos de la situation actuelle en lisant ce post :
          [en] https://blog.tox.chat/2015/07/current-situation-3/\n"
echo "------ DESCRIPTION ------
Le script effectue les modifications suivantes sur votre système :
Étape 1: qTox va être désinstallé.
Étape 2: L'ancienne clé d'installation va être remplacée par la nouvelle.
           (cf. https://pkg.tox.chat/pubkey.gpg)
Étape 3: La source du paquet APT de Tox va être remplacée.
Étape 4: qTox va être installé depuis le nouveau dépôt du Projet Tox.
-------------------------
"

askContinue 'En utilisant ce script il se peut que votre mot de passe (sudo) soit demandé
        (demande du système, non pas du script)' ; checkExit

echo 'Si qTox est installé, on le supprime...'
sudo apt-get purge -y qtox ; checkExit

#remove old key
echo "Suppression de l'ancienne clé d'installation (0C2E03A0)..."
sudo apt-key del 0C2E03A0 ; checkExit

echo "Modification du fichier '/ etc/apt/sources.list.d/tox.list' (ajout de la nouvelle clé d'installation)..."
sudo sh -c 'echo "deb https://pkg.tox.chat/ nightly main" > /etc/apt/sources.list.d/tox.list' ; checkExit

echo "Téléchargement et certification de la nouvelle clé d'installation depuis
          https://pkg.tox.chat/pubkey.gpg"
wget -qO - https://pkg.tox.chat/pubkey.gpg | sudo apt-key add - ; checkExit

echo 'Mise à jour du dépôt APT du Projet Tox. Cela peut prendre quelques instants...'
sudo apt-get update -qq ; checkExit

echo 'Installation des paquets nécessaires pour Tox...'
sudo apt install -y apt-transport-https ; checkExit
echo 'Le dépôt officiel du Projet Tox (PPA) a été mis à jour.'

askContinue 'Voulez vous installer qTox depuis le nouveau dépôt ? '
sudo apt install -y qtox ; checkExit


echo '
----------------------------------------
|  qTox a été mis à jour avec succès.  |
----------------------------------------
'
