#run as sudo
#installs admin panel into /var/www/html
sudo apt-get install -y php5 php5-curl
git clone https://github.com/BitSeed-org/BitcoinNodeAdmin
sudo cp -r BitcoinNodeAdmin/wallet_dark/* /var/www/html
sudo chown www-data:www-data /var/www/html
