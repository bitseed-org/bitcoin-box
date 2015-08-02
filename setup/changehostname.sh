#change host name
sudo hostname bitseed
sudo rm /etc/hostname
sudo echo "bitseed" >> /etc/hostname
sudo rm /etc/hosts
sudo cp /home/linaro/bitcoin-box/setup/hosts /etc/
