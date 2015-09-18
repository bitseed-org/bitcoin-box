
#dependencies
sudo apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libgmp-dev libtool libboost-all-dev
sudo apt-get install -y libqrencode-dev libqtgui4
sudo apt-get install -y libqt4-dev libprotobuf-dev protobuf-compiler
sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y bsdmainutils

sudo apt-get install -y apache2

#Berkeley db 4.8 for wallet
#mkdir /home/linaro/deb
cd /home/linaro/deb
#wget https://bittylicious.com/downloads/db4.8-util_4.8.30-11ubuntu1_armhf.deb
#wget https://bittylicious.com/downloads/libdb4.8++_4.8.30-10precise1_armhf.deb
#wget https://bittylicious.com/downloads/libdb4.8_4.8.30-11ubuntu1_armhf.deb
#wget https://bittylicious.com/downloads/libdb4.8++-dev_4.8.30-10precise1_armhf.deb
#wget https://bittylicious.com/downloads/libdb4.8-dev_4.8.30-11ubuntu1_armhf.deb


#sudo dpkg -i db4.8-util_4.8.30-11ubuntu1_armhf.deb
#sudo dpkg -i libdb4.8++_4.8.30-10precise1_armhf.deb
#sudo dpkg -i libdb4.8_4.8.30-11ubuntu1_armhf.deb
#sudo dpkg -i libdb4.8++-dev_4.8.30-10precise1_armhf.deb
#sudo dpkg -i libdb4.8-dev_4.8.30-11ubuntu1_armhf.deb
#sudo apt-get install -f
cd ~

#get binaries
#echo "getting bitcoin binaries"
#cd /home/linaro
#wget http://www.bitseed.org/device/bitcoin0.10.0/bitcoin-cli
#wget http://www.bitseed.org/device/bitcoin0.10.0/bitcoind
#wget http://www.bitseed.org/device/bitcoin0.10.0/bitcoin-tx
#wget http://www.bitseed.org/device/bitcoin0.10.0/bitcoin.conf
#wget http://www.bitseed.org/device/bitcoin0.10.0/bitcoin-qt

chmod 755 bitcoind
chmod 755 bitcoin-cli
chmod 755 bitcoin-qt
chmod 755 bitcoin-tx

#get scripts
cd ~
#git clone https://github.com/BitSeed-org/bitcoin-box
cp -r /home/linaro/bitcoin-box/.hdd/* /home/linaro
chmod 755 /home/linaro/*.sh

#disable HDD disk write cache - reduce chance of corruption due to power loss
sudo chown linaro:linaro /etc/hdparm.conf
echo 'write_cache = off' >> /etc/hdparm.conf
sudo chown root:root /etc/hdparm.conf

echo "next step:  download blockchain"
echo "bitcoin setup complete" >> /home/linaro/setup.log
