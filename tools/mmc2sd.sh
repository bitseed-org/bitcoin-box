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

main
