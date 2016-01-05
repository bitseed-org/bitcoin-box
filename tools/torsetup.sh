#!/bin/bash
#Script to install Tor on Bitseed V2
#run as sudo

#add Tor repository sources
sudo echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get update

#install Tor - it will start automatically
sudo apt-get install -y tor deb.torproject.org-keyring
mkdir $HOME/.bitseed
echo "onion=1" >> $HOME/.bitseed/bitseed.conf

#Configure Tor to be a hidden service so that other Tor nodes can connect to your node
sudo echo "HiddenServiceDir /var/lib/tor/bitcoin-service/" >> /etc/tor/torrc
sudo echo "HiddenServicePort 8333 127.0.0.1:8333" >> /etc/tor/torrc
sudo service tor reload
sleep 10s
#get onion address
sudo cat /var/lib/tor/bitcoin-service/hostname > $HOME/onionaddr
echo $HOME/onionaddr
onion=$(<$HOME/onionaddr)

# configure bitcoin.conf
sh /home/linaro/btcstop.sh
#Tor Settings
echo "onlynet=Tor" >> $HOME/.bitcoin/bitcoin.conf
echo "onion=127.0.0.1:9050" >> $HOME/.bitcoin/bitcoin.conf
echo "listen=1" >> $HOME/.bitcoin/bitcoin.conf
echo "bind=127.0.0.1:8333" >> $HOME/.bitcoin/bitcoin.conf
echo "externalip=$onion" >> $HOME/.bitcoin/bitcoin.conf

#these are other Tor nodes that will help your node find peers
echo "seednode=nkf5e6b7pl4jfd4a.onion" >> $HOME/.bitcoin/bitcoin.conf
echo "seednode=xqzfakpeuvrobvpj.onion" >> $HOME/.bitcoin/bitcoin.conf
echo "seednode=tsyvzsqwa2kkf6b2.onion" >> $HOME/.bitcoin/bitcoin.conf
#these lines help limit potential DOS attacks over Tor
echo "banscore=10000" >> $HOME/.bitcoin/bitcoin.conf
echo "bantime=11" >> $HOME/.bitcoin/bitcoin.conf

#sh /home/linaro/btcstart.sh
echo "1" > $HOME/restartflag
echo "Tor will now run automatically and publish the bitcoin node as a hidden service"
echo "Bitcoin will only connect to peers over the Tor Onion network."
echo "run ./btcwatch.sh to start bitcoin now"
