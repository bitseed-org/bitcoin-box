#Copies contents of /home mounted drive to USB drive on sdb1
#this is a production tool
sudo mkfs.ext4 /dev/sdb1
echo "disk formatted ext4"
echo"mounting disk as sdb1"
sudo mount /dev/sdb1 /mnt/sdb1
echo "copying bitcoin files 2015-03-25"
sudo mkdir /mnt/sdb1
sudo mkdir /mnt/sdb1/linaro
sudo rsync -r --info=progress2 /home/linaro/ /mnt/sdb1/linaro
