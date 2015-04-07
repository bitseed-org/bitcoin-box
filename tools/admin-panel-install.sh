#run as sudo
#installs admin panel into /var/www/html
git clone https://github.com/BitSeed-org/BitcoinNodeAdmin
sudo cp -r BitcoinNodeAdmin/wallet_dark /var/www/html/
sudo chown www-date:www-data /var/www/html
