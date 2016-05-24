#!/bin/bash
#upgrades from original Bitseed V2 GUI to v2.1.0
#must run as sudo

sudo apt-get update
rm -rf bitcoin-box
bash gitclone.sh
sudo bash $HOME/bitcoin-box/setup/admin-v2.1-install.sh

#install Tor to support new bitcoin onion routing


./btcstop.sh

echo "maxuploadtarget=1000" >> $HOME/.bitcoin/bitcoin.conf
echo "maxmempool=400" >> $HOME/.bitcoin/bitcoin.conf
echo "#onlynet=onion"  >> $HOME/.bitcoin/bitcoin.conf

sudo reboot
