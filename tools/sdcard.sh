backup_to_sdcard()
{
    device=`ls /sys/block/ | grep "mmcblk"`
    device="/dev/${device}"
    format_sdcard ${device} 16 $SD_SIZE_BACKUP
    ret=$?
    nanda_dir=/tmp/nanda
    p1_dir=/tmp/${device}p1
    p2_dir=/tmp/${device}p2
    if [ $ret -eq 0 ]; then
        ret=1
        mkdir -p $p2_dir && mount ${device}p2 $p2_dir &&
        echo -n "copying nanda to sdcard..." &&
        dd if=/dev/nanda bs=1M of=${p2_dir}/nanda.img >/dev/null 2>&1 && echo -$
        echo -n "copying nandb to sdcard..." &&
        dd if=/dev/nandb bs=1M of=${p2_dir}/nandb.img >/dev/null 2>&1 && echo -$
        echo -n "copying nandd to sdcard, will take abount 10 minutes..." &&
        dd if=/dev/nandd bs=1M of=${p2_dir}/nandd.img >/dev/null 2>&1 && sync &$
        umount ${device}p2 &&
        rm -rf $p2_dir &&
        # copy uImage and script.bin from nanda to mmcblkXp1
        echo -n "make the card bootable..." &&
mkdir -p $p1_dir &&
        mount ${device}p1 $p1_dir &&
        mkdir -p $nanda_dir &&
        mount /dev/nanda $nanda_dir &&
        cp ${nanda_dir}/uImage $p1_dir/ &&
        cp ${nanda_dir}/script.bin $p1_dir/ &&
        cp /boot-mmc/uEnv.txt $p1_dir/ &&
        cat > ${p1_dir}/restore_tty1.sh << EOF &&
#!/bin/sh
/sbin/getty -n -l /mnt/restore.sh 115200 /dev/tty1 vt100
EOF
        cat > ${p1_dir}/restore_ttyS0.sh << EOF &&
#!/bin/sh
/sbin/getty -n -l /mnt/restore.sh 115200 /dev/ttyS0 vt100
EOF
        cat > ${p1_dir}/restore.sh << EOF &&
#!/bin/sh
# restore.sh, used to restore whole system from sdcard to nand flash

mount_dir=/tmp/mnt
mkdir -p \$mount_dir
partitions="nanda nandb nandd"
pid="/tmp/\`basename \$0\`.pid"

echo 0 > /proc/sys/kernel/printk
killall blink_led.sh
/blink_led.sh 18 1000000 &
while [ 1 ]; 
do
    clear
    echo -e "\n\n"
    echo -e "\n\tThe sdcard you inserted is a restore-card."
    echo -e "\n\tIt is used to restore the whole system on nand flash."
    echo -e "\n\tIf you do not want to restore the system, please plug out the $
    echo -e "\n\tand press reset button to reboot."
    echo -e -n "\n\tDo you want to restore system on nand flash? (Y/N) "
    read answer
    if ! [ "\$answer" = "Y" ] && ! [ "\$answer" = "y" ]; then
        sleep 1
    else
        # check whether restore.sh is already running
        if [ -f \$pid ] && [ -d /proc/\`cat \$pid\` ]; then
            echo -e "\n\t\$0 is already running now, please wait it finish"
            exit 0
        fi
        mount /dev/mmcblk0p2 \${mount_dir} || echo "mount failed \`exit 1\`"
        echo \$\$ > \$pid
        break;
    fi
done

IMG_SIZE=\`du -s \${mount_dir}  | cut -f1\`
BURN_TIME=\`expr \$IMG_SIZE / 1024 / 3 / 60\`
echo -e "\n\n\n\trestore system to nand flash, will take abount \$BURN_TIME min$
/blink_led.sh 18 100000 &
ret=0
for i in \$partitions
do
    dd if=\${mount_dir}/\${i}.img of=/dev/\${i} bs=1M > /dev/null 2>&1
    if [ \$? -ne 0 ]; then
        ret=1
        break;
    fi
done

if [ \$ret -eq 0 ]; then
    echo "[done]" 
    echo -e "\n\tRestore finish, plug out the card and press reset button boot $
    killall blink_led.sh
    /blink_led.sh 18 1000000 & 
    /blink_led.sh 19 1000000 &         
else
    echo "[failed]"
    killall blink_led.sh   
    /blink_led.sh 18 100000 &
    /blink_led.sh 19 100000 &
fi
while [ 1 ]; do
    sleep 10
done
EOF
 sync &&
        umount /dev/nanda &&
        umount ${device}p1 &&
        rm -rf $nanda_dir $p1_dir >/dev/null 2>&1 &&
        write_uboot_to_sd ${device} &&
        ret=0 &&
        echo -e $DONE
    fi

    if [ $ret -eq 0 ]; then
        sleep 3
        whiptail --msgbox "backup succeed!" $H $W 1
    else
        echo -e $FAIL && sleep 3
        return $ret
    fi
}
#
###### backup steps ######
# 1. partition the sdcard and format 
# 2. backup, dump images( nanda, nandb, nandd ) to mmcblk0p2
# 3. create restore script to the sdcard, and make it bootable
###### restore steps ######
# 1. run restore script to notify user whether restore is needed
#
backup()
{
    whiptail --yesno "Do you want to backup your system from nand flash to sdca$
        Need to insert an empty sdcard ( >= $SD_SIZE_BACKUP MBytes )" $H $W 1 \
        3>&1 1>&2 2>&3
    ret=$?
    
    while [ $ret -eq 0 ]; do
        ret=1
        sdcard_insert=0
        cat /proc/partitions | grep "mmcblk" > /dev/null 2>&1 && 
        sdcard_insert=1
        [ $sdcard_insert -eq 0 ] && whiptail --yesno "No sdcard inserted. Do yo$
        [ $sdcard_insert -eq 1 ] && ret=0 && break
    done
    if [ $ret -eq 0 ]; then
        whiptail --yesno "Do you really want to format this card? " $H $W 1\
            3>&1 1>&2 2>&3
        ret=$?
        if [ $ret -eq 0 ]; then
            backup_to_sdcard && return 0
        else
 return 1
        fi
    fi
    return 1

clone_to_sdcard()
{
    device=`ls /sys/block/ | grep "mmcblk"`
    device="/dev/${device}"
    p2size=`cat /sys/block/nand/nandd/size`
    p2size=`expr $p2size / 2048`
    
    format_sdcard ${device} 16 $p2size
    ret=$?
    nanda_dir=/tmp/nanda
    p1_dir=/tmp/${device}p1
    if [ $ret -eq 0 ]; then
        ret=1
        echo -n "copying nandd to sdcard, will take abount 10 minutes..." &&
        dd if=/dev/nandd bs=1M of=${device}p2 >/dev/null 2>&1 && sync && echo -$
        # copy uImage and script.bin from nanda to mmcblkXp1
        echo -n "make the card bootable..." &&
        mkdir -p $p1_dir &&
        mount ${device}p1 $p1_dir &&
        mkdir -p $nanda_dir &&
        mount /dev/nanda $nanda_dir &&
cp ${nanda_dir}/uImage $p1_dir/ &&
        cp ${nanda_dir}/script.bin $p1_dir/ &&
        cp /boot-mmc/uEnv.txt $p1_dir/ &&
        sync &&
        umount /dev/nanda &&
        umount ${device}p1 &&
        rm -rf $nanda_dir $p1_dir >/dev/null 2>&1 &&
        write_uboot_to_sd ${device} &&
        ret=0 &&
        echo -e $DONE
    fi

    if [ $ret -eq 0 ]; then
        sleep 3
        whiptail --msgbox "clone system from nand to mmc card succeed!" $H $W 1
    else
        echo -e $FAIL && sleep 3
        return $ret
    fi        
}
###### clone steps ######
# 1. partition the sdcard and format
# 2. dump nandd to mmcblk0p2
# 3. copy uImage/script.bin/uEnv.txt to mmcblk0p1
# 4. make the card bootable
#
make_mmc_boot()
{
whiptail --yesno "Do you want to clone your system from nand flash to sdcar$
        Need to insert an empty sdcard ( >= $SD_SIZE_CLONE MBytes )" $H $W 1 \
        3>&1 1>&2 2>&3
    ret=$?
 
    while [ $ret -eq 0 ]; do
        ret=1
        sdcard_insert=0
        cat /proc/partitions | grep "mmcblk" > /dev/null 2>&1 && 
        sdcard_insert=1
        [ $sdcard_insert -eq 0 ] && whiptail --yesno "No sdcard inserted. Do yo$
        [ $sdcard_insert -eq 1 ] && ret=0 && break
    done
    if [ $ret -eq 0 ]; then
        whiptail --yesno "Do you really want to format this card? " $H $W 1\
            3>&1 1>&2 2>&3
        ret=$?
        if [ $ret -eq 0 ]; then
            clone_to_sdcard && return 0
        else
            return 1
        fi
    fi
    return 1
}

do_exit() 
{
    if ! [ -f $board_conf ]; then
        whiptail --msgbox "Please set the screen resolution" $H $W 1
        return 0
    fi
 if [ $locale_mode -eq $LOCALE_EN_ONLY ]; then
        echo "remove language packs"
        apt-get remove $chinese_packs && apt-get autoremove
    fi
    
    if [ $need_to_reboot -eq 1 ]; then
        echo "Board configuration changed, system will reboot in 5 seconds"
        sleep 5 && sync && reboot
    fi
    clear
    exit 0
}


