#!/bin/bash
#downloads an update notification script from bitseed.org
#this script is run by crontab
rm /home/linaro/v2update.sh
auto=$(awk -F ' *= *' '$1=="autoupdate"{print $2}' $HOME/.bitseed/bitseed.conf)
if (( $auto == 1 )); then
   wget https://www.bitseed.org/device/updater/v2update.sh
   chmod 755 /home/linaro/v2update.sh
   echo "update check $(date)" >> $HOME/cron.log
fi   
exit
