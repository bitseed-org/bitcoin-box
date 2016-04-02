#!/bin/bash
#stop bitcoind and update blockchain backup
#check if backups are disabled
disable=$(awk -F ' *= *' '$1=="disablebackups"{print $2}' $HOME/.bitseed/bitseed.conf)
if (( $disable != 1 )); then
#check that bitcoin is running
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then 
  echo "btc not running"
  echo "btc not running $(date)" >> $HOME/bak.log 
else
  echo "stop bitcoind to run backup"  
  sh /home/linaro/btcstop.sh
  sleep 5s 
  echo "backing up db"
  rsync --delete -a --checksum --info=progress2 -r /home/linaro/.bitcoin /home/linaro/livebak
  echo $(date) >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/bak.log
  echo "backup complete. restart bitcoind"
  sh /home/linaro/btcstart.sh
fi
