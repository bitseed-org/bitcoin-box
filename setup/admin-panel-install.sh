#run as sudo
#installs admin panel into /var/www/html
#sudo apt-get install -y php5 php5-curl
git clone https://github.com/BitSeed-org/BitcoinNodeAdmin
sudo cp -r BitcoinNodeAdmin/wallet_dark/* /var/www/html
sudo chown www-data:www-data /var/www/html
sudo /etc/init.d/apache2 restart
echo "edit /home/linaro/reward-addr with your bitcoin address for the bitnodes incentive program"
echo "replace this line with your bitcoin address" > /home/linaro/reward-addr

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
