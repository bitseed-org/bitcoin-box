#prep OS
sudo apt-get update
#install nano for editing (and ntp to set the system clock - may not be needed for 14.12)
sudo apt-get install -y nano
#install hdparm so disk write cache can be disabled - reduce corruption due to power loss
sudo apt-get install -y hdparm
#sudo apt-get install -y ntp
#sudo service ntp restart
sudo apt-get install -y dnsutils
sudo apt-get -y upgrade
#rsync for database backup sync
sudo apt-get install -y rsync
#allow device to generate a new mac
sudo rm /etc/mac #delete mac address so device will geneate new address at 1st boot
#prep btc script
sudo chmod 755 btcsetup.sh
sudo chmod 755 *.sh

#disable screensaver becuase it uses too much CPU
#rm /home/linaro/.config/lxsession/LXDE/autostart
#echo "@lxpanel --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
#echo "@pcmanfm --desktop --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
#echo "@/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1" >> /home/linaro/.config/lxsession/LXDE/autostart

#backup /home/linaro directory
rm -rf Templates
rm -rf Arduino
mkdir /tmp/tmp2
cp -r /home/linaro/. /tmp/tmp2

#format HDD
#echo "HDD formating"
#echo -e "o\nn\np\n1\n\n\nw" | sudo fdisk /dev/sda
#sudo mkfs.ext4 /dev/sda1

#add line to /etc/fstab to mount hdd
echo "mount HDD and setup fstab automount"
sudo echo '/dev/sda1   /home   ext4   defaults  0  2' >> /etc/fstab
#mkdir /home
sudo mount -a
sudo chown -R linaro:linaro /home

#restore files to home directory /home/linaro
mkdir /home/linaro
cp -r /tmp/tmp2/. /home/linaro

#swapfile setup
echo "1GB swapfile setup on HDD"
#dd line below not needed if hdd is pre-imaged with swapfile
dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576
sudo chown root:root /home/swapfile
sudo chmod 0600 /home/swapfile
sudo mkswap /home/swapfile
sudo swapon  /home/swapfile
sudo echo '/home/swapfile   none   swap  sw   0  0' >> /etc/fstab

#change host name
sudo hostname bitseed
sudo rm /etc/hostname
sudo echo "bitseed" >> /etc/hostname
sudo rm /etc/hosts
sudo cp /home/linaro/bitcoin-box/setup/hosts /etc/

echo "4" > $HOME/restartflag
echo "next step:  reboot via sudo reboot"
echo "after reboot, run ./btcsetup.sh"
echo "device setup complete" >> /home/linaro/setup.log
