#!/bin/bash
#installs and configures software for bitseed V2
#must run as sudo
#reboot when complete.  Device will have a new mac and ip address

sudo rm /etc/mac
cp /home/linaro/bitcoin-box/.hdd/*.sh /home/linaro
sudo chown -R linaro:linaro /home/linaro
chmod 755 /home/linaro/*.sh
chmod 755 /home/linaro/bitcoin-box/setup/*sh
sudo cp /home/linaro/bitcoin-box/.hdd/safestop.sh /root

#install php GUI
#public UI on port 80
#private coontrols on port 81
sudo ./admin-v2-install.sh
sudo chmod 666 /home/linaro/restartflag

#set serial number
echo "Enter device serial number:"
read serial
echo $serial > /home/linaro/"deviceid-$serial"
echo $serial > /var/www/html/serial
sudo chown www-data:www-data /var/www/html/serial

#disable screensaver becuase it uses too much CPU
sudo mv /etc/init/lxdm.conf /etc/init/lxdm.conf.nostart
rm /home/linaro/.config/lxsession/LXDE/autostart
echo "@lxpanel --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@pcmanfm --desktop --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1" >> /home/linaro/.config/lxsession/LXDE/autostart

#dd line below not needed if hdd is pre-imaged with swapfile
echo "setting up swap"
dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576
sudo chown root:root /home/swapfile
sudo chmod 0600 /home/swapfile
sudo mkswap /home/swapfile
sudo swapon  /home/swapfile

echo "200" > /home/linaro/version
sudo chown linaro:linaro /home/linaro/checkupdates.sh
echo "quickset done" >> /home/linaro/bitcoin-box/setup/setup.log
