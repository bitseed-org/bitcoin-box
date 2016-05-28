#!/bin/bash
#upgrades from original Bitseed V2 GUI to v2.1.0
#must run as sudo

vers=$( < /home/linaro/version)
echo "version: $vers"
if [ "$vers" -gt "209" ]; then
  echo "already at v2.1.0"
  exit
fi
sudo apt-get update
rm -rf bitcoin-box
rm master.zip
bash gitclone.sh
sudo bash $HOME/bitcoin-box/setup/admin-v2.1-install.sh

#install Tor to support new bitcoin onion routing
sudo apt-get install -y tor
sudo apt-get -y autoremove
sudo echo "HiddenServiceDir /var/lib/tor/bitseed-service/" >> /etc/tor/torrc
sudo echo "HiddenServicePort 80 127.0.0.1:82" >> /etc/tor/torrc
sudo echo "ControlPort 9051" >> /etc/tor/torrc
sudo echo "CookieAuthentication 1" >> /etc/tor/torrc
sudo usermod -a -G debian-tor linaro 
sudo service tor restart
sleep 5
echo "Your Onion status page address:"
sudo cat /var/lib/tor/bitseed-service/hostname

./btcstop.sh

echo "maxuploadtarget=1000" >> $HOME/.bitcoin/bitcoin.conf
echo "maxmempool=400" >> $HOME/.bitcoin/bitcoin.conf
echo "#onlynet=onion"  >> $HOME/.bitcoin/bitcoin.conf

sudo reboot
