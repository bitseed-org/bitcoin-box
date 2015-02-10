#run from SD card, copies SD card image to NAND
sudo umount /dev/mmcblk0p1
sudo mkdir /media/bootsd
sudo mkdir /media/boot #create mount point for boot flash part of nand
sudo mount /dev/nanda /media/boot #mount the boot flash
sudo mount /dev/mmcblk0p1 /media/bootsd
sudo cp /media/bootsd/script.bin /media/boot/ #xfer to boot flash
sudo cp /media/bootsd/uImage /media/boot/ #xfer to boot flash
sudo dd if=/dev/mmcblk0p2 of=/dev/nandd bs=1M # dd live root file system to nandd root fs
sudo sync;
sudo umount /media/boot
sudo umount /media/bootsd
sudo rm -r /media/boot /media/bootsd /media/rootfs
