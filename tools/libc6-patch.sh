#security patch to upfate glibc library
#security patch
sudo echo "deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security main universe" >> /etc/apt/sources.list
sudo echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security main universe" >> /etc/apt/sources.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com ADCE2AF3A4E0014F
sudo sed -i '/wiimu/d' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y libc-dev-bin libc6 libc6-armel libc6-dev
echo "202" > /home/linaro/version
sleep 5
sudo dpkg -l libc6 libc6-dev libc6-armel libc-dev-bin >> /home/linaro/bitcoin-box/setup/setup.log
sudo dpkg -l libc6 libc6-dev libc6-armel libc-dev-bin
echo "glibc (libc6) patch completed.  reboot is recommended"
