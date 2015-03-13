#dependencies
sudo pacman -S --noconfirm build-essential libtool autotools-dev autoconf pkg-config libssl-dev libgmp-dev libtool libboost-all-dev

sudo pacman -S --noconfirm libqt4-dev libprotobuf-dev protobuf-compiler libminiupnpc-dev bsdmainutils libqrencode-dev

#Berkeley db 4.8 for wallet
mkdir /home/namecoin/deb
cd /home/namecoin/deb
wget https://bittylicious.com/downloads/db4.8-util_4.8.30-11ubuntu1_armhf.deb
wget https://bittylicious.com/downloads/libdb4.8++_4.8.30-10precise1_armhf.deb
wget https://bittylicious.com/downloads/libdb4.8_4.8.30-11ubuntu1_armhf.deb
wget https://bittylicious.com/downloads/libdb4.8++-dev_4.8.30-10precise1_armhf.deb
wget https://bittylicious.com/downloads/libdb4.8-dev_4.8.30-11ubuntu1_armhf.deb
sudo dpkg -i db4.8-util_4.8.30-11ubuntu1_armhf.deb
sudo dpkg -i libdb4.8++_4.8.30-10precise1_armhf.deb
sudo dpkg -i libdb4.8_4.8.30-11ubuntu1_armhf.deb
sudo dpkg -i libdb4.8++-dev_4.8.30-10precise1_armhf.deb
sudo dpkg -i libdb4.8-dev_4.8.30-11ubuntu1_armhf.deb
#sudo apt-get install -f
cd ~

#get binaries
echo "getting bitcoin binaries"
cd /home/namecoin
wget http://www.bitseed.org/bc-blockchain/binaries/btc0.10.0/bitcoin-cli
wget http://www.bitseed.org/bc-blockchain/binaries/btc0.10.0/bitcoind
wget http://www.bitseed.org/bc-blockchain/binaries/btc0.10.0/bitcoin-qt
wget http://www.bitseed.org/bc-blockchain/binaries/btc0.10.0/bitcoin-tx
chmod 755 bitcoind
chmod 755 bitcoin-cli
chmod 755 bitcoin-qt

#get script
cd ~
#git clone https://github.com/BitSeed-org/bitcoin-box
#cp -r /home/linaro/bitcoin-box/.hdd/* /home/linaro
chmod 755 /home/namecoin/*.sh
