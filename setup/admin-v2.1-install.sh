#run as sudo
#installs admin panel into /var/www/html
#sudo apt-get install -y php5 php5-curl
sudo rm -rf $HOME/BitcoinNodeAdmin
sudo rm -rf $HOME/UI_konn.zip
sudo rm -rf $HOME/bitseed-web-ui-master
#git clone https://github.com/BitSeed-org/BitcoinNodeAdmin
#wget https://github.com/bitseed-org/BitcoinNodeAdmin/archive/UI_konn.zip
wget https://github.com/bitseed-org/bitseed-web-ui/archive/master.zip
unzip master.zip
#rename to BitcoinNodeAdmin
mv bitseed-web-ui-master BitcoinNodeAdmin

sudo cp -r BitcoinNodeAdmin/wallet_light/* /var/www/html
sudo mkdir /var/www/public
sudo mkdir /var/www/onion
sudo cp -r BitcoinNodeAdmin/wallet_light/* /var/www/public
sudo cp BitcoinNodeAdmin/public/index.php /var/www/public/
sudo cp -r BitcoinNodeAdmin/wallet_light/* /var/www/onion
sudo cp BitcoinNodeAdmin/public/onion/index.php /var/www/onion/
sudo chown -R www-data:www-data /var/www
sudo chmod 666 /home/linaro/restartflag

#Apache config
sudo cp BitcoinNodeAdmin/public/000-default.conf  /etc/apache2/sites-enabled/
sudo cp BitcoinNodeAdmin/public/ports.conf  /etc/apache2/
sudo cp BitcoinNodeAdmin/wallet_light/php/*.txt /var/www/html

sudo chmod 666 /var/www/html/*.txt
sudo chmod 666 /home/linaro/.bitcoin/bitcoin.conf
sudo cp /home/linaro/bitcoin-box/.hdd/bconf $HOME
sudo cp BitcoinNodeAdmin/wallet_light/homedir_scripts/* $HOME
sudo cp BitcoinNodeAdmin/wallet_light/homedir_scripts/.bitseed/bitseed.conf $HOME/.bitseed/
cp $HOME/bitcoin-box/.hdd/restartbtc.sh $HOME
touch $HOME/rd_bconf_flag
touch $HOME/wr_bconf_flag
touch $HOME/wr_bconf_mbox
touch $HOME/rd_bconf_mbox
sudo chown linaro:linaro $HOME/*.py
sudo chown linaro:linaro $HOME/*.sh
sudo chown linaro:linaro $HOME/*flag
sudo chown linaro:linaro $HOME/*mbox
sudo chmod 755 $HOME/*.py
sudo chmod 755 $HOME/*.sh
sudo chmod 666 $HOME/rd_bconf_flag
sudo chmod 666 $HOME/wr_bconf_flag
sudo chmod 666 /home/linaro/bconf
sudo chmod 666 $HOME/wr_bconf_mbox
sudo chmod 666 $HOME/rd_bconf_mbox
sudo cp /home/linaro/bitcoin-box/.hdd/updateflag $HOME
sudo chmod 666 /home/linaro/updateflag
sudo cp /home/linaro/bitcoin-box/.hdd/startbtc.conf /etc/init

mkdir $HOME/.bitseed
sudo cp /home/linaro/bitcoin-box/.hdd/bitseed.conf $HOME/.bitseed
sudo echo "210" > /home/linaro/version
sudo /etc/init.d/apache2 restart

#echo "edit /home/linaro/reward-addr with your bitcoin address for the bitnodes incentive program"
echo "replace this line with your bitcoin address" > /home/linaro/reward-addr
sudo cp /home/linaro/bitcoin-box/.hdd/checkupdates.sh $HOME
sudo chown 755 /home/linaro/checkupdates.sh
sudo apt-get install -y dnsutils

echo "web admin install done" > /home/linaro/bitcoin-box/setup/setup.log

#-------------------------------------------
#Upgrading Bitseed devcies S/N 30 and earlier
#-----------------------------------------
#stop bitcoin via ./btcstop.sh
#edit ~/.bitcoin/bitcoin.conf and change the rpcpassword to "bitseed"
#(the rpcpassword in bitcoin.conf and config.inc.php must the the same)
#upgrade scripts
#rm -rf bitcoin-box
#./gitclone.sh
#cp /home/linaro/bitcoin-box/.hdd/*.sh /home/linaro
#sudo chown -R linaro:linaro /home/linaro
#chmod 755 /home/linaro/*.sh
#cd bitcoin-box/setup
#chmod 755 ./admin-panel-install.sh
#sudo ./admin-panel-install.sh
