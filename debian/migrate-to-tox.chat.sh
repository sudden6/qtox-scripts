#! /bin/sh

. gettext.sh

script_name=$0
script_dir=$(dirname $script_name)

TEXTDOMAIN=$script_name
export TEXTDOMAIN

TEXTDOMAINDIR=$script_dir/locale
export TEXTDOMAINDIR


# function definitions

checkExit() {
    err_code=$?
    if [ ! $err_code -eq 0 ] ; then
      eval_gettext "An error has occurred. (Error code \$err_code)"; echo
      exit 1;
    fi
}

askContinue() {
    question=$1
    while true; do
        read -p "$question (y/n)" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) gettext "Aborted."; echo; exit 2;;
            * ) gettext "Press key to answer \"y\" (yes) or \"n\" (no)."; echo;;
        esac
    done
}


# main program

gettext "


PLEASE READ THE NOTE BELOW BEFORE YOU CONTINUE!!!


"; echo

eval_gettext "Hello \$USER!"; echo
gettext "
For organisational reasons, the Tox Project URL has changed from \`tox.im\` to \`tox.chat\`. This script replaces the installed qTox with an updated version."; echo
gettext "
You can find more details on the current situation in the following blog entry:
https://blog.tox.chat/2015/07/current-situation-3/"; echo
gettext "
----- DESCRIPTION -----
The script makes the following changes to your system:
Step 1: qTox will first be uninstalled!
Step 2: The installation key will be replaced to the new one.
           (see https://pkg.tox.chat/pubkey.gpg)
Step 3: The APT package source will be updated.
Step 4: qTox is installed via the new APT repository for Tox Project.
-------------------------
"; echo


askContinue "`gettext "You will need to enter your sudo password (asked by the system). Continue?"`"; checkExit


gettext "If qTox is installed, deleting it..."; echo
sudo apt-get purge -yqq qtox ; checkExit

#remove old key
gettext "Removing the old installation key (0C2E03A0)..."; echo
sudo apt-key del 0C2E03A0 ; checkExit

gettext "Editing the file \`/etc/apt/sources.list.d/tox.list\` (which contains the new Tox Project APT repository)"; echo
sudo sh -c 'echo "deb https://pkg.tox.chat/ nightly main" > /etc/apt/sources.list.d/tox.list' ; checkExit

gettext "Downloading and signing the new installation key from https://pkg.tox.chat/pubkey.gpg"; echo
wget -qO - https://pkg.tox.chat/pubkey.gpg | sudo apt-key add - ; checkExit

gettext "Updating the Tox Project APT repositories. This may take some time..."; echo
sudo apt-get update -qq ; checkExit

gettext "Installing necessary packages for Tox..."; echo
sudo apt install -y apt-transport-https ; checkExit
gettext "The Tox Project package source (PPA) has been installed."; echo

askContinue "`gettext "Should I install qTox from the new official repository?"`"
sudo apt install -y qtox ; checkExit


gettext "
----------------------------------------
| qTox has been updated successfully.  |
----------------------------------------
"; echo
