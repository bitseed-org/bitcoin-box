#prep OS
#install nano for editing (and ntp to set the system clock - may not be needed for 14.12)
sudo pacman -Syy
#rsync for database backup sync
sudo pacman -S --noconfirm rsync

#format HDD
#echo "HDD formating"
#echo -e "o\nn\np\n1\n\n\nw" | sudo fdisk /dev/sda
#sudo mkfs.ext4 /dev/sda1

#add line to /etc/fstab to mount hdd
echo "mount HDD and setup fstab automount"
sudo echo '/dev/sda1   /home   ext4   defaults  0  2' >> /etc/fstab
#mkdir /home
sudo mount -a

#restore files to home directory /home/linaro
#mkdir /home/linaro
#cp -r /tmp/tmp2/. /home/linaro

#swapfile setup
echo "1GB swapfile setup on HDD"
#dd line below not needed if hdd is pre-imaged with swapfile
#sudo dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576
sudo chown root:root /home/swapfile
sudo chmod 0600 /home/swapfile
sudo mkswap /home/swapfile
sudo swapon  /home/swapfile
sudo echo '/home/swapfile   none   swap  sw   0  0' >> /etc/fstab

#change host name
#sudo hostname btc
#sudo rm /etc/hostname
#sudo echo "btc" >> /etc/hostname
#sudo rm /etc/hosts
#sudo cp /home/linaro/bitcoin-box/setup/hosts /etc/
