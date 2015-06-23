#!/bin/bash
#Linksprite script for basic config of the board
# this script only run for
#   1. the first time bootup ( /etc/board.conf is not exist )
#   2. keyboard "F8/1/A" is pressed during boot
#   3. user call it ( without parameters )
export LANG="C.UTF-8"
export LANGUAGE="en_US:en"
call_by_user=1
FAIL="\E[31;40m\033[1m\t[fail]\033[0m"
DONE="\E[31;40m\033[3m\t[done]\033[0m"
#seconds
TIMEOUT=35
#width
W=70
#height
H=20
#list height
LH=10
board_conf=/etc/board.conf
lang_conf=/etc/default/locale
expand_script=/usr/bin/expand_sdcard_rootfs.sh

screen_change=0
screen_mode=640x480-60
old_mode=$screen_mode
need_to_reboot=0
screen_next_step=0
mem_is_256m=1

# for locale setting
LOCALE_EN=0
LOCALE_EN_ONLY=1
LOCALE_CN=2
locale_mode=$LOCALE_EN
chinese_packs="language-pack-gnome-zh-hans language-pack-gnome-zh-hant ttf-wqy-microhei ibus-googlepinyin ibus-gtk zenity im-switch"

argc=$#
arg0=$0
# arg1 = 9 call from rcS
# arg1 = 8, arg2=old_mode, arg3=new_mode, call by self, for screen resolution changed
arg1=$1
arg2=$2
arg3=$3

SD_SIZE_CLONE=4000
SD_SIZE_BACKUP=5000

write_uboot_to_sd()
{
     dev=$1
     ret=1
     cat /proc/cpuinfo | grep "sun7i"
     if [ $? -eq 0 ]; then
         dd if=/boot-mmc/u-boot-sunxi-with-spl.bin bs=1024 seek=8 of=${dev} >/dev/null 2>&1 &&
         ret=0
     else
         dd if=/boot-mmc/sunxi-spl.bin of=${dev} bs=1024 seek=8 >/dev/null 2>&1 &&
         dd if=/boot-mmc/u-boot.bin of=${dev} bs=1024 seek=32 >/dev/null 2>&1 &&
         ret=0
     fi
     return $ret
}

update_board_config()
{
    arg=$1
    key=`echo $arg | cut -d'=' -f1`
    value=`echo $arg | cut -d'=' -f2`
    grep "$key=" $board_conf >/dev/null 2>&1 || echo "$key=" >> $board_conf &&
    sed $board_conf -r -i -e "s/$key=.*/$key=$value/"
}

check_env()
{
    first_boot=0

    if [ $(id -u) -ne 0 ]; then
        echo -e "must be run as root. try 'sudo $arg0'"
        exit 1
    fi

    boot_from_nand=0
    cat /proc/mounts  | grep "/ " | grep "nandd" && boot_from_nand=1
    if [ $boot_from_nand -eq 1 ]; then
        if [ -f /etc/need_resize ]; then
            resize2fs /dev/nandd && rm -f /etc/need_resize
        fi
    fi

    mem_size=`cat /proc/meminfo | grep "MemTotal" | cut -d':' -f 2 | cut -d'k' -f1`
    mem_size=`expr $mem_size`
    if [ $mem_size -gt 262144 ]; then
        mem_is_256m=0
    fi

    # fix for 256m version
    if [ $mem_is_256m -eq 1 ]; then
        mv /usr/share/X11/xorg.conf.d/10-disp.conf /usr/share/X11/xorg.conf.d/10-disp.conf_ 2>/dev/null
        rm -rf /lib/modules/3.4.29+/kernel/drivers/gpu 2>/dev/null
        rm -f /usr/share/applications/lxrandr.desktop
        rm -f /usr/bin/lxrandr
    fi

    # screen resolution changed ?
    if [ $argc -eq 3 ] && [ $arg1 -eq 8 ]; then
        screen_change=1
        call_by_user=0
        return 0;
    fi

    if [ $argc -eq 1 ] && [ $arg1 -eq 9 ]; then
        call_by_user=0
    fi

    if ! [ -f $board_conf ]; then
        first_boot=1
    fi

    if [ -f /etc/need_fct ]; then
        first_boot=0
    fi

    clear
    # disable kernel message
    echo 0 > /proc/sys/kernel/printk

    if [ $call_by_user -eq 1 ] || [ $first_boot -eq 1 ]; then
        return
    fi

    # check if F8/1/A is pressed, timeout is 3 seconds
    echo -e "\n\n\E[31;40m\033[1m\tPress [F8/1/A] to enter board-config menu\033[0m\n\n"
    /usr/bin/check_key 3 66 2 30
    if [ $? -eq 0 ]; then
        call_by_user=1
    fi

    if [ $call_by_user -eq 0 ]; then
        exit 0;
    fi
}

change_screen_xorg()
{
    modes=`cat /usr/share/X11/xorg.conf.d/10-disp.conf | grep "Modeline" | grep "#" -v | cut -d'"' -f2 | sort -nr`
    str="$screen_mode <*>"
    for i in $modes
    do
        x=`echo $i | cut -d'x' -f1`
        y=`echo $i | cut -d'x' -f2 | cut -d'-' -f1`
        if [ $x -gt 1920 ] || [ $x -eq 1920 ] && [ $y -gt 1080 ]; then
            continue
        fi

        grep "$i" /tmp/exclude.txt >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            continue
        fi

        j=`echo -e "\n$i <>"`
        str="${str}$j"
    done
    ret=`whiptail --menu  "Select screen resolution:" $H $W $LH \
        $str \
        3>&1 1>&2 2>&3`

    if [ "$ret" != "" ]; then
        old_mode=$screen_mode
        screen_mode=$ret
        screen_next_step=1
    else
        screen_next_step=0
    fi
}

change_screen_fbmode()
{
    modes=`cat /etc/fb.modes  | grep "#" -v | grep "mode" | grep "endmode" -v | cut -d'"' -f2 | sort -nr`
    str="$screen_mode <*>"
    for i in $modes
    do
        x=`echo $i | cut -d'x' -f1`
        y=`echo $i | cut -d'x' -f2 | cut -d'-' -f1`
        if [ $x -gt 1920 ] || [ $x -eq 1920 ] && [ $y -gt 1080 ]; then
            continue
        fi

        grep "$i" /tmp/exclude.txt >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            continue
        fi

        j=`echo -e "\n$i <>"`
        str="${str}$j"
    done
    ret=`whiptail --menu  "Select screen resolution:" $H $W $LH \
        $str \
        3>&1 1>&2 2>&3`

    if [ "$ret" != "" ]; then
        need_to_reboot=1
        old_mode=$screen_mode
        screen_mode=$ret
        screen_next_step=1
    else
        screen_next_step=0
    fi
}


# for ddr 256MB version, mali is disabled, use fbset to change screen
# else change xorg.conf
change_screen()
{
    tty | grep /dev/tty > /dev/null 2>&1 || tty | grep /dev/console > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        whiptail --msgbox "if you want to change screen resolution, please run `basename $0` from command line mode, press Ctrl+Alt+<F1-F6> switch to command line, and press Ctrl+Alt+F7 switch back" $H $W 1
        return 0
    fi
# these modes do not show in board-config menu
cat << EOF > /tmp/exclude.txt
1856x1392-75
1856x1392-60
1856x1392-120R
1792x1344-75
1792x1344-120R
1680x1050-85
1680x1050-120R
1600x1200-120R
1600x1200-85
1440x900-75
1440x900-85
1440x900-120R
1400x1050-85
1400x1050-60
1400x1050-120R
1360x768-120R
1280x960-120R
1280x800-85
1280x800-60
1280x768-120R
1280x1024-120R
1024x768-120R
800x600-85
800x600-120R
EOF
    if [ $mem_is_256m -eq 0 ]; then
        change_screen_xorg
    else
        change_screen_fbmode
    fi

    if [ $screen_next_step -eq 1 ]; then
whiptail --msgbox "Screen resolution will change to $screen_mode.\n
Press Y to save or N to cancel in the next step.\n
If no selection is made within $TIMEOUT seconds, your change will not be saved."\
        $H $W 1
        fbset -a $screen_mode
        /usr/bin/set_window.sh
        $arg0 8 $old_mode $screen_mode
        exit
    fi
}

save_screen()
{
    if [ $mem_is_256m -eq 0 ]; then
        sed /usr/share/X11/xorg.conf.d/10-disp.conf -r -i -e "s/Modes.*/Modes \"$screen_mode\"/"
    else
        sed /etc/init.d/rcS -r -i -e "s/fbset.*/fbset -a \"$screen_mode\"/"
    fi
}

change_window_percent()
{
    percent=`cat /etc/screen.conf | cut -d' ' -f1`
    str="$percent <*>"
    for(( i=100; i>=50; --i ));
    do
        j=`echo -e "\n$i <>"`
        str="${str}$j"
    done

    ret=`whiptail --menu  "Adjust Screen Size % of full size" $H $W $LH \
        $str \
        3>&1 1>&2 2>&3`
    if [ "$ret" != "" ]; then
        /usr/bin/setwindow $ret 1 0 0
    fi
}

get_screen_mode()
{
    mode=`cat /etc/board.conf | grep "screen_mode=" | cut -d'=' -f2`
    if [ $? -eq 0 ] && [ $mode != "" ]; then
        screen_mode=$mode
    fi
    old_mode=$screen_mode
}

change_password()
{
    whiptail --msgbox "Change password for 'ubuntu' user(init password is 'ubuntu')" $H $W 1
    passwd ubuntu &&
    whiptail --msgbox "Password changed successfully" $H $W 1
}

set_locale()
{
    ret=`whiptail --menu  "Set default language" $H $W $LH \
        "1" "English" \
        "2" "Chinese(Simplified)" \
        "3" "Chinese(Traditional)" \
        3>&1 1>&2 2>&3`

    case $ret in
        "1")
        locale_mode=$LOCALE_EN
        lang="C.UTF-8"
        language="en_US:en"
        whiptail --yesno "Do you want to remove other languages to save space? " $H $W 1 \
            3>&1 1>&2 2>&3
        if [ $? -eq 0 ]; then
            locale_mode=$LOCALE_EN_ONLY
        fi
        ;;

        "2")
        locale_mode=$LOCALE_CN
        lang="zh_CN.UTF-8"
        language="zh_CN:zh:en_US:en"
        ;;

        "3")
        locale_mode=$LOCALE_CN
        lang="zh_TW.UTF-8"
        language="zh_TW:zh:en_US:en"
        ;;

        *)
        locale_mode=$LOCALE_EN
        lang="C.UTF-8"
        language="en_US:en"
        ;;
    esac

    if [ $locale_mode -eq $LOCALE_CN ]; then
        required_packages=""
        for i in $chinese_packs;
        do
            dpkg -s "$i" 2>/dev/null| grep "Status:" | grep "installed" >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                required_packages="$required_packages $i"
            fi
        done

        if [ "$required_packages" != "" ]; then
            ret=1
            whiptail --yesno "The following packages will be installed:\n\n$required_packages\n\n Do you want to continue? " $H $W 1 \
            3>&1 1>&2 2>&3
            if [ $? -eq 0 ]; then
                apt-get update
                apt-get install -y $required_packages &&
                ret=0
            fi

            if [ $ret -ne 0 ]; then
                whiptail --msgbox "Install required packages failed!\n\nSet default language to English." $H $W 1
                lang="C.UTF-8"
                language="en_US:en"
            fi
        fi
    fi
    grep "LANG=" $lang_conf >/dev/null 2>&1 || echo "LANG=" >> $lang_conf &&
    grep "LANGUAGE=" $lang_conf  >/dev/null 2>&1 || echo "LANGUAGE=" >> $lang_conf &&
    sed $lang_conf -r -i -e "s/LANG=.*/LANG=\"$lang\"/" &&
    sed $lang_conf -r -i -e "s/LANGUAGE=.*/LANGUAGE=\"$language\"/"
}

set_timezone()
{
    dpkg-reconfigure tzdata
}

set_keyboard()
{
    dpkg-reconfigure keyboard-configuration
}

expand_rootfs()
{
    whiptail --yesno "Do you really want to expand rootfs of your sdcard?" $H $W 1
    if [ $? -ne 0 ]; then
        return 0
    fi
    START_SECTOR=`cat /sys/block/mmcblk0/mmcblk0p2/start`
        umount /dev/mmcblk0
    fdisk /dev/mmcblk0 << EOF
d
2
n
p
2
$START_SECTOR

w
EOF

    cat << EOF > $expand_script
#!/bin/sh
cat /proc/cmdline | grep "root=/dev/mmcblk0p2"
if [ \$? -eq 0 ]; then
    sudo resize2fs /dev/mmcblk0p2 | tee /dev/ttyS0
fi
EOF
    chmod +x $expand_script
    need_to_reboot=1
}

set_boot()
{
    ret=`whiptail --menu  "Set boot mode" $H $W $LH \
        "1" "boot to desktop" \
        "2" "command line(run \"lightdm\" manually to enter to desktop) " \
        3>&1 1>&2 2>&3`

    case $ret in
        "1")
        update_board_config "boot_mode=lightdm"
        ;;

        "2")
        update_board_config "boot_mode=text"
        ;;

        *)
        return 0
        ;;
    esac
}

update()
{
    ret=`whiptail --menu  "Which package do you want to update?" $H $W $LH \
        "none" "just update apt source list" \
        "config" "board-config" \
        "kernel" "kernel and drivers"\
        "arduino-ide" "Arduino IDE" \
        "xbmc" "XBMC Media Center" \
        "dev" "arduino c libraries" \
        "all"  "config, kernel, arduino-ide, xbmc, dev" \
        3>&1 1>&2 2>&3`

    case $ret in
        "none")
        apt-get update
        ;;

        "all")
        apt-get update
        apt-get install pcduino-config pcduino-kernel pcduino-arduino-ide pcduino-xbmc pcduino-dev
        ;;

        # cancel, do nothing
        "")
        ;;

        *)
        apt-get update
        apt-get install pcduino-${ret}
        ;;
    esac
    sleep 5
}

format_sdcard()
{
    device=$1
    p1size=${2}M
    p2size=${3}M
    mounts=`cat /proc/mounts  | grep "$device" | cut -d' ' -f1`
    if [ "$mounts" != "" ];then
        for i in $mounts;
        do
            umount $i -l
        done
    fi
    echo -n "making partitions on ${device}..."
    fdisk $device > /tmp/log 2>&1 << EOF &&
d
4
d
3
d
2
d
1
n
p
1

+${p1size}
n
p
2

+${p2size}
p
w
EOF
    echo -e $DONE &&
    echo -n "${device}p1 formating..." &&
    mkdosfs ${device}p1 >/dev/null 2>&1 &&
    echo -e $DONE &&
    echo -n "${device}p2 formating..." &&
    mke2fs -T ext3 ${device}p2 >/dev/null 2>&1 &&
    echo -e $DONE
}


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
        dd if=/dev/nanda bs=1M of=${p2_dir}/nanda.img >/dev/null 2>&1 && echo -e $DONE &&
        echo -n "copying nandb to sdcard..." &&
        dd if=/dev/nandb bs=1M of=${p2_dir}/nandb.img >/dev/null 2>&1 && echo -e $DONE &&
        echo -n "copying nandd to sdcard, will take abount 10 minutes..." &&
        dd if=/dev/nandd bs=1M of=${p2_dir}/nandd.img >/dev/null 2>&1 && sync && echo -e $DONE &&
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
    echo -e "\n\tIf you do not want to restore the system, please plug out the sdcard,"
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
echo -e "\n\n\n\trestore system to nand flash, will take abount \$BURN_TIME minutes..."
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
    echo -e "\n\tRestore finish, plug out the card and press reset button boot from nand."
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
        cat > ${p1_dir}/update.sh << EOF &&
#!/bin/sh
TOP=\`dirname \$0\`
start-stop-daemon -K -p /tmp/tty1.pid > /dev/null 2>&1
start-stop-daemon -K -p /tmp/ttyS0.pid > /dev/null 2>&1
start-stop-daemon -S -b -x \${TOP}/restore_tty1.sh -m -p /tmp/tty1.pid
start-stop-daemon -S -b -x \${TOP}/restore_ttyS0.sh -m -p /tmp/ttyS0.pid
while [ 1 ];
do
   sleep 100
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
    whiptail --yesno "Do you want to backup your system from nand flash to sdcard? \
        Need to insert an empty sdcard ( >= $SD_SIZE_BACKUP MBytes )" $H $W 1 \
        3>&1 1>&2 2>&3
    ret=$?

    while [ $ret -eq 0 ]; do
        ret=1
        sdcard_insert=0
        cat /proc/partitions | grep "mmcblk" > /dev/null 2>&1 &&
        sdcard_insert=1
        [ $sdcard_insert -eq 0 ] && whiptail --yesno "No sdcard inserted. Do you want to retry?" $H $W 1 && ret=0
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
}


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
        dd if=/dev/nandd bs=1M of=${device}p2 >/dev/null 2>&1 && sync && echo -e $DONE &&
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
    whiptail --yesno "Do you want to clone your system from nand flash to sdcard? \
        Need to insert an empty sdcard ( >= $SD_SIZE_CLONE MBytes )" $H $W 1 \
        3>&1 1>&2 2>&3
    ret=$?

    while [ $ret -eq 0 ]; do
        ret=1
        sdcard_insert=0
        cat /proc/partitions | grep "mmcblk" > /dev/null 2>&1 &&
        sdcard_insert=1
        [ $sdcard_insert -eq 0 ] && whiptail --yesno "No sdcard inserted. Do you want to retry?" $H $W 1 && ret=0
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

# allow user login to tty2<Ctrl+Alt+F2> and ttyS0
start_ttys()
{
    ifconfig usb0 192.168.100.1 up
    /usr/sbin/dhcpd
    if [ $call_by_user -eq 1 ]; then
        return
    fi

    tty | grep /dev/console > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        start-stop-daemon -S -b -x /bin/busybox getty 115200 /dev/tty2 vt100 -m -p /tmp/tty2.pid
        start-stop-daemon -S -b -x /bin/busybox getty 115200 /dev/ttyS0 vt100 -m -p /tmp/ttyS0.pid
    fi
}

main()
{
    if [ -x $expand_script ]; then
         $expand_script && rm -f $expand_script
    fi

    check_env

    if [ $screen_change -eq 1 ]; then
        clear
        echo -e "\n\n\n\n"
        echo -e  "\tDo you want to save this resolution?(Y/N):\n"
        echo -e  "\tIf no selection is made within $TIMEOUT seconds, your"
        echo -e  "\tchange will not be saved."
        echo -e -n "\t"
        /usr/bin/get_answer Y $TIMEOUT
        if [ $? -ne 0 ]; then
            echo -e "\n\tGot answer 'N' or timeout, reset to $arg2"
            sleep 3
            fbset -a $arg2
            /usr/bin/set_window.sh
            $arg0
            exit 0
        else
            if ! [ -f /usr/share/X11/xorg.conf.d/10-disp.conf ]; then
                need_to_reboot=1
            fi
            update_board_config "screen_mode=$arg3"
            get_screen_mode
            save_screen
        fi
    else
        start_ttys
    fi
    get_screen_mode
    boot_from_sdcard=0
    cat /proc/cmdline  | grep "root=/dev/mmcblk0p2" && boot_from_sdcard=1
    while [ 1 ]; do
        if [ $boot_from_sdcard -eq 1 ]; then
            choice=`whiptail --menu "Board Configuration" $H $W $LH --cancel-button Done \
            "change_screen" "Change Ubuntu screen resolution" \
            "change_window_percent" "Adjust Screen Size % of full size" \
            "change_password" "Change password for 'ubuntu' user" \
            "set_locale" "Change language" \
            "set_timezone" "Set timezone" \
            "set_keyboard" "Set keyboard layout" \
            "set_boot" "Boot to cmdline only or desktop" \
            "expand_rootfs" "Expand sdcard root partition" \
            "update" "Update board-config and related packages" \
                3>&1 1>&2 2>&3`
        else
            choice=`whiptail --menu "Board Configuration" $H $W $LH --cancel-button Done \
            "change_screen" "Change Ubuntu screen resolution" \
            "change_window_percent" "Adjust Screen Size % of full size" \
            "change_password" "Change password for 'ubuntu' user" \
            "set_locale" "Change language" \
            "set_timezone" "Set timezone" \
            "set_keyboard" "Set keyboard layout" \
            "set_boot" "Boot to cmdline only or desktop" \
            "update" "Update board-config and related packages" \
            "backup" "Backup whole system to mmc card" \
            "make_mmc_boot" "Clone system from nand to mmc card" \
                3>&1 1>&2 2>&3`
        fi

        ret=$?
        if [ $ret -eq 1 ]; then
                    do_exit
        elif [ $ret -eq 0 ]; then
            "$choice"
            if [ $? -ne 0 ]; then
                if [ $choice == "change_screen" ]; then
                    fun_name="Change screen"
                elif [ $choice == "change_window_percent" ]; then
                    fun_name="Adjust Screen Size"
                elif [ $choice == "change_password" ]; then
                    fun_name="Change password"
                else
                    fun_name="$choice"
                fi
                whiptail --msgbox "$fun_name failed" $H $W 1
            fi
        else
            do_exit
        fi
    done
}

main
