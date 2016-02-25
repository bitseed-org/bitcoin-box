#run as sudo
#Bitcoin Core 0.12 and later can automatically relay transactions on the Tor network along side the 
#standard ipv4 network.  Tor version 2.7 or later is required
#This script will update tor and enable control port access via cookie authentication

#Add Tor respository to get latest version
sudo echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 74A941BA219EC810
sudo apt-get update
sudo apt-get install -y tor

#enable control port access so bitcoin can create hiddens service
sudo echo "ControlPort 9051" >> /etc/tor/torrc
sudo echo "CookieAuthentication 1" >> /etc/tor/torrc
sudo usermod -a -G debian-tor linaro 
sudo service tor restart
