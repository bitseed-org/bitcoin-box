#!/bin/bash
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then 
  echo "btc not running"
  echo "btc not running $(date)" >> bak.log 
else
  echo "stop bitcoind to run backup"  
  sh /home/linaro/hdd/btcstop.sh
  sleep 5s 
  echo "backing up db"
  rsync --checksum -r /home/linaro/hdd/.bitcoin /home/linaro/hdd/livebak
  echo $(date) >> /home/linaro/hdd/cron.log
  echo "db backup run $(date)" >> /home/linaro/hdd/cron.log
  echo "db backup run $(date)" >> /home/linaro/hdd/bak.log
  echo "backup complete. restart bitcoind"
  sh /home/linaro/hdd/btcstart.sh
fi
