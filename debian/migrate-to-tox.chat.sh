#! /bin/sh

checkExit() {
    if [ ! $? -eq 0 ] ; then
      echo "An error has occured. (Error code $?)";
      exit 1;
    fi
}

askContinue() {
    while true; do
        read -p "$1 (y/n)" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) echo 'Aborted.'; exit 2;;
            * ) echo 'Press to answer "y" (yes) or "n" (no)."';;
        esac
    done
}

echo "\n\n\nPLEASE READ THE FOLLOWING TEXT CAREFULLY BEFORE YOU CONTINUE!!!\n\n\n"

echo "Hello $USER!\n"
echo 'Because of changes in our organisation, the domain name (internet address) of the Tox Project has changed.  This script will replace the installed QTox version with an updated one. The old domain "tox.im" IS INVALID and was replaced with "tox.chat".'
echo ''
echo 'The reasons behind this process can be found at: 
https://blog.tox.chat/2015/07/current-situation-3/'
echo ''
echo '----- DESCRIPTION -----
The script does the following to your system:
Step 1: QTox will be removed!
Step 2: The signing key will be replaced.
           (see https://pkg.tox.chat/pubkey.gpg)
Step 3: The APT repositorys will be updated.
Step 4: If you wish, QTox will be installed again.
-------------------------
'


askContinue 'Your password is needed to continue. Continue?' ; checkExit


echo 'Removing QTox if installed...'
sudo apt-get purge -y qtox ; checkExit

#remove old key
echo 'Removing old signing key (0C2E03A0)...'
sudo apt-key del 0C2E03A0 ; checkExit
 
echo 'Replacing /etc/apt/sources.list.d/tox.list (contains new APT Repository)'
sudo sh -c 'echo "deb https://pkg.tox.chat/ nightly main" > /etc/apt/sources.list.d/tox.list' ; checkExit

echo 'Getting and installing new signing key from https://pkg.tox.chat/pubkey.gpg ...'
wget -qO - https://pkg.tox.chat/pubkey.gpg | sudo apt-key add - ; checkExit

echo 'Updating APT Repositories. This may take a few minutes...'
sudo apt-get update -qq ; checkExit

echo 'Installing Tox dependencies...'
sudo apt install -y apt-transport-https ; checkExit
echo 'Tox Repository (PPA) installed successfully.'

askContinue 'Install new QTox?'
sudo apt install -y qtox ; checkExit


echo '
----------------------------------------
| QTox updated successfully. |
----------------------------------------
'
