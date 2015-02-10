#!/bin/bash
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then 
  echo "btc not running"
  echo "btc not running $(date)" >> bak.log 
else
  echo "stop bitcoind to run backup"  
  sh /home/linaro/btcstop.sh
  sleep 5s 
  echo "backing up db"
  rsync --checksum -r /home/linaro/.bitcoin /home/linaro/livebak
  echo $(date) >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/bak.log
  echo "backup complete. restart bitcoind"
  sh /home/linaro/btcstart.sh
fi
