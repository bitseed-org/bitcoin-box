#!/bin/bash
#this script is executed by cron every minute
#if it sets updateflag to 1 ui will notify user of an update
#when user accepts update, flag is changed to 2
#when flag = 2, this script can check for it an run full update
upflag=$( < /home/linaro/updateflag)
vers=$( < /home/linaro/version)
echo "Flag: $upflag"
echo "version: $vers"
if (( vers <200 )); then
 echo "set flag to 1 to notify user"
 echo "1" > updateflag
 echo "v2update: flag set to 1 on $(date)" >> /home/linaro/cron.log
else 
echo "nothing done"
echo "0" > /home/linaro/updateflag
fi
