#
#installs Tor and configures bitcoind to run as a Tor hidden service
#run as sudo

#Install Tor
sudo rm /etc/apt/sources.list.d/tor.list
sudo echo "deb http://deb.torproject.org/torproject.org trusty main"  >> /etc/apt/sources.list.d/tor.list
sudo echo "deb-src http://deb.torproject.org/torproject.org trusty main"  >> /etc/apt/sources.list.d/tor.list
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y tor deb.torproject.org-keyring
