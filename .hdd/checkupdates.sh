#!/bin/bash
#downloads an update notification script from bitseed.org
#this script is run by crontab
rm /home/linaro/v1update.sh
rm /home/linaro/v2update.sh
wget https://www.bitseed.org/device/updater/v2update.sh
chmod 755 /home/linaro/v2update.sh
echo "update check $(date)" >> cron.log
exit
