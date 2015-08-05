#! /bin/sh

checkExit() {
    if [ ! $? -eq 0 ] ; then
      echo "An error has occurred. (Error code $?)";
      exit 1;
    fi
}

askContinue() {
    while true; do
        read -p "$1 (Y/n)" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) echo 'Canceled.'; exit 2;;
            * ) echo 'Are you sure ? (Y/n)';;
        esac
    done
}

echo "\n\n\nPLEASE READ THE NOTE BELOW BEFORE YOU CONTINUE!!!\n\n\n"

echo "Hello $USER!\n"
echo 'For organisational reasons, the Tox Project URL has changed from `tox.im` to `tox.chat`. This script replaces the installed qTox with an updated version.'
echo ''
echo 'You can find more details on the current situation in the following blog entry:
https://blog.tox.chat/2015/07/current-situation-3/'
echo ''
echo '----- DESCRIPTION -----
The script makes the following changes to your system:
Step 1: qTox will first be uninstalled!
Step 2: The installation key will be replaced to the new one.
           (see https://pkg.tox.chat/pubkey.gpg)
Step 3: The APT package source will be updated.
Step 4: qTox is installed via the new APT repository for Tox Project.
-------------------------
'


askContinue 'To use this script you will be asked to enter your sudo password
        (asked by the system, not by the script)' ; checkExit


echo 'If qTox is installed, deleting it...'
sudo apt-get purge -y qtox ; checkExit

#remove old key
echo 'Removing the old installation key (0C2E03A0)...'
sudo apt-key del 0C2E03A0 ; checkExit

echo 'Editing the file `/ etc/apt/sources.list.d/tox.list` (which contains the new Tox Project APT repository)'
sudo sh -c 'echo "deb https://pkg.tox.chat/ nightly main" > /etc/apt/sources.list.d/tox.list' ; checkExit

echo 'Downloading and signing the new installation key from https://pkg.tox.chat/pubkey.gpg'
wget -qO - https://pkg.tox.chat/pubkey.gpg | sudo apt-key add - ; checkExit

echo 'Updating the Tox Project APT repositories. This may take several times...'
sudo apt-get update -qq ; checkExit

echo 'Installing necessary packages for Tox...'
sudo apt install -y apt-transport-https ; checkExit
echo 'The Tox Project package source (PPA) has been installed.'

askContinue 'Should I install qTox from the new official repository?'
sudo apt install -y qtox ; checkExit


echo '
----------------------------------------
| qTox has been updated successfully.  |
----------------------------------------
'
