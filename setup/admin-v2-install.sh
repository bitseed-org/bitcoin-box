#run as sudo
#installs admin panel into /var/www/html
#sudo apt-get install -y php5 php5-curl
sudo rm -rf BitcoinNodeAdmin
git clone https://github.com/BitSeed-org/BitcoinNodeAdmin
sudo cp -r BitcoinNodeAdmin/wallet_light/* /var/www/html
sudo mkdir /var/www/public
sudo cp -r BitcoinNodeAdmin/wallet_light/* /var/www/public
sudo cp BitcoinNodeAdmin/public/index.php /var/www/public/
sudo chown -R www-data:www-data /var/www/html
sudo chown -R www-data:www-data /var/www/public
sudo chmod 666 /home/linaro/restartflag
sudo cp BitcoinNodeAdmin/public/000-default.conf  /etc/apache2/sites-enabled/
sudo cp BitcoinNodeAdmin/public/ports.conf  /etc/apache2/
sudo cp BitcoinNodeAdmin/wallet_light/php/*.txt /var/www/html
sudo chown www-data:www-data /var/www/html/*.txt
sudo chmod 666 /var/www/html/*.txt
sudo chmod 666 /home/linaro/.bitcoin/bitcoin.conf
sudo cp bitcoin-box/.hdd/bconf /home/linaro
sudo chmod 666 /home/linaro/bconf
sudo cp bitcoin-box/.hdd/updateflag /home/linaro
sudo chmod 666 /home/linaro/updateflag
sudo echo "200" > /home/linaro/version

sudo /etc/init.d/apache2 restart

#echo "edit /home/linaro/reward-addr with your bitcoin address for the bitnodes incentive program"
echo "replace this line with your bitcoin address" > /home/linaro/reward-addr
sudo cp /home/linaro/bitcoin-box/.hdd/checkupdates.sh /home/linaro
sudo chown 755 /home/linaro/checkupdates.sh
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
