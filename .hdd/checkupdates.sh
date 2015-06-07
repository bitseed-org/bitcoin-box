#!/bin/bash
#downloads an update notification script from bitseed.org
#this script is run by crontab
rm /home/linaro/v1update.sh
wget https://www.bitseed.org/device/updater/v1update.sh
chmod 755 /home/linaro/v1update.sh
echo "update check $(date)" >> cron.log
exit
